# Sponsor i18n

- 📦 Repository 👉🏻 https://github.com/playandprosper/i18n 🔒
- 🔓 Unlock 👉🏻 https://github.com/sponsors/andreimerlescu 🤩

## Installation

Once you've unlocked the repository, these links will work.

| OS | Arch | Size | Checksum | &nbsp; |
|---|---|---|---|---|
| Linux | amd64 | 9.13MB | `00a2554246c8ecd59e61e59691b03c3d05d3e3fc30b72f33ef85fd779c3dfe6a` | [↯](https://github.com/playandprosper/i18n/releases/download/v0.0.1/i18n-linux-amd64) |
| Linux | arm64 | 9.72MB | `13c08b36a00a89e4e3b61ebd1c7288ed3ce1630d48ec079d8bfa7ed06d671771` | [↯](https://github.com/playandprosper/i18n/releases/download/v0.0.1/i18n-linux-arm64) |
| macOS | Silicon | 9.3MB | `3b81290e3adbfcb28032ca3fecb7ef3512ddd79daa4a38142b6d37d1dfd0e3be` | [↯](https://github.com/playandprosper/i18n/releases/download/v0.0.1/i18n-darwin-arm64) |
| macOS | Intel | 9.93MB | `273f9e2aad88f3145339c5f09d976ae736cee08cd31c3abaa429ca0e37604259` | [↯](https://github.com/playandprosper/i18n/releases/download/v0.0.1/i18n-darwin-amd64) |
| Windows | amd64 | 10MB | `375ffd654185e3b68e7ee52918e8f37fe6af01f8929fd7a130d2c09c3cd67805` | [↯](https://github.com/playandprosper/i18n/releases/download/v0.0.1/i18n-amd64.exe) |
| Windows | arm64 | 9.18MB | `22cf4576657b4fa82e681ed9c6441c7a5cb409148a519e82d34f08680e5126c8` | [↯](https://github.com/playandprosper/i18n/releases/download/v0.0.1/i18n-arm64.exe) |

### Manual Installation

```bash
mkdir -p ~/work/i18n
git clone git@github.com:playandprosper/i18n.git ~/work/i18n
cd ~/work/i18n
```
#### macOS & Linux Targets

```bash
./install.sh # macos and linux targets only
```

#### Windows Targets

```cmd
./install.ps1
# or
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

## Configuration

| Flag | Type | Default | ENV |Usage |
|---|---|---|---|---|
| `-v` | `bool` | `false` | `-` | Show version |
| `-locales` | `bool` | `false` | `-` | Print every locale supported |
| `-db` | `string` | `i18n-db.json` | `I18N_DB_FILE` | Database path for json file |
| `-to` | `string` | `<empty>` | `-` | Target locale |
| `-from` | `string` | `en_US` | `-` | Source locale |
| `-key` | `string` | `<empty>` | `-` | Translation to process |
| `-text` | `string` | `<empty>` | `-` | **CLI Mode:** Translation to process |
| `-addr` | `string` | `127.0.0.1:8888` | `I18N_ADDR` |  |
| `-force` | `bool` | `false` | `-` | Ignore cache |
| `-lm-url` | `string` | `http://127.0.0.1:1234/v1` | `AI_HOST` | **Single:** LMStudio API URL  |
| `-lm-model` | `string` | `<empty>` | `AI_MODEL` | **Single:** LMStudio Model Name |
| `-lm-token` | `string` | `<empty>` | `AI_TOKEN` | AI API Token (ignore for LMStudio) |
| `-context` | `string` | `<empty>` | `-`  | **CLI Mode:** Translation context |
| `-retries` | `int` | `1` | `I18N_CLI_RETRIES`  | **CLI Mode:** Retry count before giving up |
| `-queue-size` | `int` | `8192` | `I18N_QUEUE_SIZE`  |  Maximum queued translations |
| `-max-retries` | `int` | `7` | `I18N_MAX_RETRIES`  | Maxmimum retry attempts |
| `-shutdown-wait` | `time.Duration` | `15 * time.Second` | `-`  | Shutdown drain time limit |
| `-failure-pause` | `time.Duration` | `5 * time.Minute` | `-`  | Cooldown between retries |
| `-flush-interval` | `time.Duration` | `2 * time.Minute` | `I18N_FLUSH_INTERVAL`  | DB Persistence Cadence |
| `-request-timeout` | `time.Duration` | `90 * time.Second` | `-`  | LMStudio Request Timeout |
| `-log` | `string` | `<empty>` | `I18N_LOG`  | Alias for `-log-path` and `-log-dir` |
| `-log-path` | `string` | `<empty>` | `I18N_LOG_PATH`  | File path to append new log messages |
| `-log-dir` | `string` | `<empty>` | `I18N_LOG_DIR`  | Directory for `i18n-#.log` rotated logs |
| `-log-lines` | `int` | `3000` | `I18N_LOG_LINES`  | Number of log lines to keep in memory |
| `-compile-audio` | `` | `` | `-`  |   |
| `` | `` | `` | `-`  |   |
| `` | `` | `` | `-`  |   |
| `` | `` | `` | `-`  |   |
| `` | `` | `` | `-`  |   |
| `` | `` | `` | `-`  |   |
| `` | `` | `` | `-`  |   |
| `` | `` | `` | `-`  |   |
| `` | `` | `` | `-`  |   |
| `` | `` | `` | `-`  |   |
| `` | `` | `` | `-`  |   |
| `` | `` | `` | `-`  |   |

