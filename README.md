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

```go
type duration time.Duration
type sec time.Second
type min time.Minute
type str string
```

| Flag | ENV |Usage |
|---|---|---|
| `-v` a `bool` is `false` | `-` | Show version |
| `-locales` a `bool` is `false` | `-` | Print every locale supported |
| `-db` a `str` is `i18n-db.json` | `I18N_DB_FILE` | Database path for json file |
| `-to` a `str` is `<empty>` | `-` | Target locale |
| `-from` a `str` is `en_US` | `-` | Source locale |
| `-key` a `str` is `<empty>` | `-` | Translation to process |
| `-text` a `str` is `<empty>` | `-` | **CLI Mode:** Translation to process |
| `-addr` a `str` is `127.0.0.1:8888` | `I18N_ADDR` | HTTP Daemon Process Port |
| `-force` a `bool` is `false` | `-` | Ignore cache |
| `-lm-server` a `[]str` is `<empty>` | `LM_SERVER` | CSV of `URL=MODEL` LM Studio Hosts |
| `-lm-url` a `str` is `http://127.0.0.1:1234/v1` | `AI_HOST` | **Single:** LMStudio API URL  |
| `-lm-model` a `str` is `<empty>` | `AI_MODEL` | **Single:** LMStudio Model Name |
| `-lm-token` a `str` is `<empty>` | `AI_TOKEN` | AI API Token (ignore for LMStudio) |
| `-context` a `str` is `<empty>` | `-`  | **CLI Mode:** Translation context |
| `-retries` a `int` is `1` | `I18N_CLI_RETRIES`  | **CLI Mode:** Retry count before giving up |
| `-queue-size` a `int` is `8192` | `I18N_QUEUE_SIZE`  |  Maximum queued translations |
| `-max-retries` a `int` is `7` | `I18N_MAX_RETRIES`  | Maxmimum retry attempts |
| `-shutdown-wait` a `duration` is `15 * sec` | `-`  | Shutdown drain time limit |
| `-failure-pause` a `duration` is `5 * min` | `-`  | Cooldown between retries |
| `-flush-interval` a `duration` is `2 * min` | `I18N_FLUSH_INTERVAL`  | DB Persistence Cadence |
| `-request-timeout` a `duration` is `90 * sec` | `-`  | LMStudio Request Timeout |
| `-log` a `string` is `<empty>` | `I18N_LOG`  | Alias for `-log-path` and `-log-dir` |
| `-log-path` a `str` is `<empty>` | `I18N_LOG_PATH`  | File path to append new log messages |
| `-log-dir` a `str` is `<empty>` | `I18N_LOG_DIR`  | Directory for `i18n-#.log` rotated logs |
| `-log-lines` a `int` is `3000` | `I18N_LOG_LINES`  | Number of log lines to keep in memory |
| `-compile-audio` a `bool` is `false` | `-`  | Compile Voicebox TTS |
| `-wav-dir` a `str` is `i18n_wav` | `I18N_WAV_DIR`  | Directory for .wav audio |
| `-mp3-dir` a `str` is `i18n_mp3` | `I18N_MP3_DIR`  | Directory for .mp3 audio |
| `-voicebox-url` a `str` is `http://127.0.0.1:17493` | `VOICEBOX_URL`  | `voicebox-server` bind address |
| `-voicebox-profile` a `str` is `<empty>` | `VOICEBOX_PROFILE_ID`  | Voice ID to use |
| `-voicebox-engine` a `str` is `<empty>` | `VOICEBOX_ENGINE`  | Voicebox Engine to use |
| `-voicebox-token` a `str` is `<empty>` | `VOICEBOX_TOKEN`  | Voicebox API Bearer Token |
| `-audio-timeout` a `duration` is `5 * min` | `-`  | Max allowed process time per entry |
| `-audio-retries` a `int` is `3` | `-`  | Max retires for failed audio |
| `-audio-force` a `bool` is `false` | `-`  | Ignore cached audio files and regenerate |
| `-audio-strict` a `bool` is `false` | `-`  | Abort entire compile on single key failure |
| `-audio-require-language` a `bool` is `false` | `-`  | Fail for missing languages |
| `-audio-plan` a `bool` is `false` | `-`  | Print and exit audio locales for usage |
| `-voicebox-capabilities` a `bool` is `false` | `-`  | Dump voicebox capabilities and exit |
| `-audio-workers` a `int` is `1` | `I18N_AUDIO_WORKERS`  | Number of voicebox hosts to use |
| `-audio-background` a `bool` is `false` | `-`  | Render `.wav` in background |
| `-voicebox-server` a `[]str` is `<empty>` | `VOICEBOX_SERVER`  |   |
| `-portal` a `bool` is `true` | `-`  | Enable the HTTP Portal |
| `-portal-port` a `int` is `4444` | `I18N_PORTAL_PORT`  | Portal Launched on Port |
| `-portal-token` a `str` is `<empty>` | `I18N_PORTAL_TOKEN`  | Specify the password to the portal |
| `-portal-page-size` a `int` is `100` | `I18N_PORTAL_PAGE_SIZE`  | Items per page in Portal |
| `-portal-prune-every` a `int` is `144` | `I18N_PORTAL_PRUNE_EVERY`  | Empty trash every #-days |
| `-transcode` a `bool` is `fase` | `-`  | Convert `.wav` to `.mp3` |
| `-ffmpeg` a `str` is `ffmpeg` | `I18N_FFMPEG`  | Path to `ffmpeg` binary |
| `-mp3-bitrate` a `str` is `48k` | `I18N_MP3_BITRATE`  | Bitrate for `.mp3` files |
| `-transcode-workers` a `int` is `1` | `I18N_TRANSCODE_WORKERS`  | Concurrent ffmpeg processes |
| `-transcode-scan-interval` a `duration` is `5 * min` | `-`  | `.wav` to `.mp3` interval cooldown |
| `-transcode-failure-pause` a `duration` is `30 * min` | `I18N_TRANSCODE_FAILURE_PAUSE`  | Cooldown between retries |
| `-transcode-keep-wav` a `bool` is `false` | `-`  | Leave `.wav` after `.mp3` verified |




