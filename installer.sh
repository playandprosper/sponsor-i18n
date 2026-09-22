#!/usr/bin/env bash
# installer.sh: install i18n as a systemd service (Debian/Ubuntu/Rocky/RHEL)
#
#   sudo ./installer.sh               install or upgrade
#   sudo ./installer.sh --force-env   rewrite /etc/i18n/i18n.env from current variables
#   sudo ./installer.sh --uninstall   remove the service (data and env file are kept)
#
# Any variable below can be overridden at install time, e.g.
#   sudo DAEMON_PORT=9999 EXTRA_ARGS="-transcode" ./installer.sh --force-env

set -euo pipefail

if (( BASH_VERSINFO[0] < 5 || (BASH_VERSINFO[0] == 5 && BASH_VERSINFO[1] < 1) )); then
  echo "Bash version must be 5.1 or newer (current version: $BASH_VERSION)" >&2
  exit 1
fi

usage() {
  sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'
}

FORCE_ENV=0
UNINSTALL=0
for arg in "$@"; do
  case "$arg" in
    --force-env) FORCE_ENV=1 ;;
    --uninstall) UNINSTALL=1 ;;
    -h|--help)   usage; exit 0 ;;
    *)           echo "Unknown argument: $arg" >&2; usage; exit 1 ;;
  esac
done

if [[ $EUID -ne 0 ]]; then
  echo "Run as root: sudo $0 $*" >&2
  exit 1
fi

if ! command -v systemctl >/dev/null 2>&1; then
  echo "systemctl not found; this installer requires systemd." >&2
  exit 1
fi

: "${SERVICE_NAME="i18n"}"
: "${SERVICE_USER="i18n"}"
: "${WEB_GROUP=""}"                 # auto-detected: www-data, nginx, apache
: "${BIN_DEST="/usr/local/bin/i18n"}"

: "${BASE="/var/www/i18n.software"}"
: "${PORTAL_PORT="4444"}"
: "${DAEMON_PORT="8888"}"
: "${ADDR="127.0.0.1:${DAEMON_PORT}"}"
: "${DB_DIR="${BASE}/private/db"}"
: "${DB="${DB_DIR}/i18n.software.db"}"
: "${WAV_DIR="${BASE}/public/wav"}"
: "${MP3_DIR="${BASE}/public/mp3"}"
: "${LOG_DIR="${BASE}/private/logs"}"
: "${PORTAL_PASS=""}"
: "${EXTRA_ARGS=""}"

# SELinux: auto | on | off
: "${SELINUX_MANAGE="auto"}"
# let the web server (httpd_t, which includes php-fpm) connect to the daemon
: "${SELINUX_HTTPD_CONNECT="1"}"

ENV_DIR="/etc/i18n"
ENV_FILE="${ENV_DIR}/${SERVICE_NAME}.env"
UNIT_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

gen_pass() {
  { command -v genwordpass && genwordpass; } || od -An -tx1 -N24 /dev/urandom | tr -d ' \n'
}

# ----------------------------------------------------------------- SELinux
selinux_active() {
  case "${SELINUX_MANAGE}" in
    off) return 1 ;;
    on)  return 0 ;;
  esac
  command -v getenforce >/dev/null 2>&1 || return 1
  [[ "$(getenforce)" != "Disabled" ]]
}

ensure_semanage() {
  if ! command -v semanage >/dev/null 2>&1; then
    echo "⏳ installing policycoreutils-python-utils for semanage"
    dnf -y install policycoreutils-python-utils >/dev/null
  fi
}

# add or modify a persistent file-context rule for a directory tree
set_fcontext() {
  local type="$1" path="$2"
  local spec="${path}(/.*)?"
  if semanage fcontext -l -C | grep -qF "${spec} "; then
    semanage fcontext -m -t "${type}" "${spec}"
  else
    semanage fcontext -a -t "${type}" "${spec}"
  fi
}

remove_fcontext() {
  local path="$1"
  semanage fcontext -d "${path}(/.*)?" 2>/dev/null || true
}

selinux_setup() {
  ensure_semanage

  # audio: web server may read, not write
  set_fcontext httpd_sys_content_t "${WAV_DIR}"
  set_fcontext httpd_sys_content_t "${MP3_DIR}"

  # private state: relabel so the web server cannot read it, even though
  # it lives under /var/www, which defaults to httpd_sys_content_t
  set_fcontext var_lib_t "${BASE}/private"
  set_fcontext var_lib_t "${DB_DIR}"
  set_fcontext var_log_t "${LOG_DIR}"

  restorecon -RF "${BASE}"
  restorecon -F "${BIN_DEST}" "${UNIT_FILE}"
  restorecon -RF "${ENV_DIR}"

  if [[ "${SELINUX_HTTPD_CONNECT}" == "1" ]]; then
    if [[ "$(getsebool httpd_can_network_connect | awk '{print $3}')" != "on" ]]; then
      echo "⏳ enabling httpd_can_network_connect (this takes a few seconds)"
      setsebool -P httpd_can_network_connect 1
    fi
  fi

  echo "✅ SELinux contexts applied ($(getenforce))"
}

selinux_report() {
  local ctx
  ctx="$(ps -eo label,comm | awk '$2 == "i18n" {print $1; exit}')"
  [[ -n "${ctx}" ]] && echo "   process context: ${ctx}"

  if command -v ausearch >/dev/null 2>&1; then
    local denials
    denials="$(ausearch -m AVC,USER_AVC -ts recent 2>/dev/null \
      | grep -E "comm=\"(i18n|ffmpeg|nginx|httpd|php-fpm)\"|${BASE}" || true)"
    if [[ -n "${denials}" ]]; then
      echo "⚠️  SELinux denials in the last 10 minutes:" >&2
      echo "${denials}" | tail -n 20 >&2
      echo "   Explain them with: ausearch -m AVC -ts recent | audit2why" >&2
    else
      echo "✅ no SELinux denials in the last 10 minutes"
    fi
  fi
}

# ---------------------------------------------------------------- uninstall
if (( UNINSTALL )); then
  systemctl disable --now "${SERVICE_NAME}" 2>/dev/null || true
  rm -f "${UNIT_FILE}"
  systemctl daemon-reload

  if selinux_active && command -v semanage >/dev/null 2>&1; then
    for p in "${WAV_DIR}" "${MP3_DIR}" "${BASE}/private" "${DB_DIR}" "${LOG_DIR}"; do
      remove_fcontext "${p}"
    done
    restorecon -RF "${BASE}" 2>/dev/null || true
    echo "✅ SELinux file-context rules removed"
    echo "   httpd_can_network_connect left as-is; other apps may depend on it."
  fi

  echo "✅ ${SERVICE_NAME} service removed."
  echo "   Kept: ${ENV_FILE}, ${BIN_DEST}, and everything under ${BASE}."
  exit 0
fi

# ------------------------------------------------------------------ binary
SRC_BIN="${I18N_BIN:-$(command -v i18n || true)}"
if [[ -z "${SRC_BIN}" || ! -x "${SRC_BIN}" ]]; then
  echo "Cannot find the i18n binary. Put it on PATH or set I18N_BIN=/path/to/i18n." >&2
  exit 1
fi

# install(1) writes a new file, so it takes bin_t from /usr/local/bin rather than
# carrying over a label such as user_home_t, which mv would preserve
if [[ "$(readlink -f "${SRC_BIN}")" != "$(readlink -f "${BIN_DEST}")" ]]; then
  install -m 0755 -o root -g root "${SRC_BIN}" "${BIN_DEST}"
  echo "✅ installed $("${BIN_DEST}" -v 2>/dev/null || echo i18n) to ${BIN_DEST}"
else
  echo "✅ ${BIN_DEST} already in place"
fi

# -------------------------------------------------------------- user/dirs
if ! id -u "${SERVICE_USER}" >/dev/null 2>&1; then
  useradd --system --no-create-home \
    --home-dir "${BASE}/private" \
    --shell /usr/sbin/nologin \
    "${SERVICE_USER}"
  echo "✅ created system user ${SERVICE_USER}"
fi

detect_web_group() {
  local g
  for g in "${WEB_GROUP}" www-data nginx apache; do
    if [[ -n "${g}" ]] && getent group "${g}" >/dev/null 2>&1; then
      echo "${g}"
      return
    fi
  done
  echo ""
}

WEB_GROUP="$(detect_web_group)"
if [[ -z "${WEB_GROUP}" ]]; then
  echo "⚠️  no web server group found (www-data, nginx, apache)."
  echo "   Audio dirs will be group-owned by ${SERVICE_USER}; rerun with WEB_GROUP=<group>."
  WEB_GROUP="${SERVICE_USER}"
else
  echo "✅ web server group: ${WEB_GROUP}"
fi

# private state: only the service user
install -d -m 0750 -o "${SERVICE_USER}" -g "${SERVICE_USER}" "${BASE}/private" "${DB_DIR}" "${LOG_DIR}"
# public audio: readable by the web server group; setgid keeps new files in that group
install -d -m 2750 -o "${SERVICE_USER}" -g "${WEB_GROUP}" "${WAV_DIR}" "${MP3_DIR}"

# --------------------------------------------------------------- env file
GENERATED_PASS=""
install -d -m 0755 -o root -g root "${ENV_DIR}"

if [[ ! -f "${ENV_FILE}" || ${FORCE_ENV} -eq 1 ]]; then
  if [[ -z "${PORTAL_PASS}" ]]; then
    PORTAL_PASS="$(gen_pass)"
    GENERATED_PASS="${PORTAL_PASS}"
  fi

  umask 077
  cat > "${ENV_FILE}" <<EOF
# i18n runtime options. Edit, then run: systemctl restart ${SERVICE_NAME}
I18N_DB="${DB}"
I18N_ADDR="${ADDR}"
I18N_LOG_DIR="${LOG_DIR}"
I18N_PORTAL_PORT="${PORTAL_PORT}"
I18N_PORTAL_TOKEN="${PORTAL_PASS}"
I18N_PORTAL_PRUNE_EVERY="17"
I18N_SHUTDOWN_WAIT="17s"
I18N_WAV_DIR="${WAV_DIR}"
I18N_MP3_DIR="${MP3_DIR}"
I18N_QUEUE_SIZE="1000"
I18N_LOG_LINES="9999"

# Anything else, space separated, e.g.
# I18N_EXTRA_ARGS="-transcode -lm-url http://127.0.0.1:1234/v1 -lm-model qwen3.8-27b"
I18N_EXTRA_ARGS="${EXTRA_ARGS}"
EOF
  umask 022
  chown root:root "${ENV_FILE}"
  chmod 0600 "${ENV_FILE}"
  echo "✅ wrote ${ENV_FILE}"
else
  echo "✅ kept existing ${ENV_FILE} (use --force-env to rewrite)"
fi

# ------------------------------------------------------------- unit file
cat > "${UNIT_FILE}" <<EOF
[Unit]
Description=i18n translation daemon
Documentation=https://github.com/playandprosper/sponsor-i18n
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=${SERVICE_USER}
Group=${SERVICE_USER}
SupplementaryGroups=${WEB_GROUP}
EnvironmentFile=${ENV_FILE}
WorkingDirectory=${BASE}/private
UMask=0027

ExecStart=${BIN_DEST} \\
  -db \${I18N_DB} \\
  -addr \${I18N_ADDR} \\
  -log-dir \${I18N_LOG_DIR} \\
  -portal \\
  -portal-port \${I18N_PORTAL_PORT} \\
  -portal-prune-every \${I18N_PORTAL_PRUNE_EVERY} \\
  -portal-token \${I18N_PORTAL_TOKEN} \\
  -shutdown-wait \${I18N_SHUTDOWN_WAIT} \\
  -wav-dir \${I18N_WAV_DIR} \\
  -mp3-dir \${I18N_MP3_DIR} \\
  -queue-size \${I18N_QUEUE_SIZE} \\
  -log-lines \${I18N_LOG_LINES} \\
  \$I18N_EXTRA_ARGS

Restart=on-failure
RestartSec=5s
# must exceed -shutdown-wait so the queue can drain before SIGKILL
TimeoutStopSec=45s

NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
PrivateTmp=true
PrivateDevices=true
ProtectKernelTunables=true
ProtectControlGroups=true
ReadWritePaths=${DB_DIR} ${LOG_DIR} ${WAV_DIR} ${MP3_DIR}

[Install]
WantedBy=multi-user.target
EOF
chmod 0644 "${UNIT_FILE}"
echo "✅ wrote ${UNIT_FILE}"

# ---------------------------------------------------------------- SELinux
if selinux_active; then
  selinux_setup
fi

# ----------------------------------------------------------------- start
systemctl daemon-reload
systemctl enable "${SERVICE_NAME}" >/dev/null
systemctl restart "${SERVICE_NAME}"

set -a
# shellcheck disable=SC1090
source "${ENV_FILE}"
set +a

healthy=0
for _ in $(seq 1 15); do
  if curl -fsS --max-time 2 "http://${I18N_ADDR}/metrics" >/dev/null 2>&1; then
    healthy=1
    break
  fi
  sleep 1
done

if (( healthy )); then
  echo "✅ ${SERVICE_NAME} is up on ${I18N_ADDR} (portal on :${I18N_PORTAL_PORT})"
else
  echo "❌ ${SERVICE_NAME} did not answer on http://${I18N_ADDR}/metrics within 15s" >&2
  systemctl --no-pager --lines=20 status "${SERVICE_NAME}" >&2 || true
  selinux_active && selinux_report
  exit 1
fi

if selinux_active; then
  selinux_report
fi

if [[ -n "${GENERATED_PASS}" ]]; then
  echo
  echo "🚨 Portal password (shown once, stored in ${ENV_FILE}):"
  echo "   ${GENERATED_PASS}"
fi

echo
echo "Edit options:  sudo \$EDITOR ${ENV_FILE}"
echo "Apply:         sudo systemctl restart ${SERVICE_NAME}"
echo "Logs:          journalctl -u ${SERVICE_NAME} -f   (and ${LOG_DIR})"
