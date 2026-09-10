# Sponsor i18n

- 📦 Repository 👉🏻 https://github.com/playandprosper/i18n 🔒
- 🔓 Unlock 👉🏻 https://github.com/sponsors/andreimerlescu 🤩

## Installation

Once you've unlocked the repository, these links will work.

| Target | Size | Checksum | &nbsp; |
|---|---|---|---|
| Linux `amd64` | 9.13MB | `00a2554246c8ecd59e61e59691b03c3d05d3e3fc30b72f33ef85fd779c3dfe6a` | [↯](https://github.com/playandprosper/i18n/releases/download/v0.0.1/i18n-linux-amd64) |
| Linux `arm64` | 9.72MB | `13c08b36a00a89e4e3b61ebd1c7288ed3ce1630d48ec079d8bfa7ed06d671771` | [↯](https://github.com/playandprosper/i18n/releases/download/v0.0.1/i18n-linux-arm64) |
| macOS `Silicon` | 9.3MB | `3b81290e3adbfcb28032ca3fecb7ef3512ddd79daa4a38142b6d37d1dfd0e3be` | [↯](https://github.com/playandprosper/i18n/releases/download/v0.0.1/i18n-darwin-arm64) |
| macOS `Intel` | 9.93MB | `273f9e2aad88f3145339c5f09d976ae736cee08cd31c3abaa429ca0e37604259` | [↯](https://github.com/playandprosper/i18n/releases/download/v0.0.1/i18n-darwin-amd64) |
| Windows `amd64` | 10MB | `375ffd654185e3b68e7ee52918e8f37fe6af01f8929fd7a130d2c09c3cd67805` | [↯](https://github.com/playandprosper/i18n/releases/download/v0.0.1/i18n-amd64.exe) |
| Windows `arm64` | 9.18MB | `22cf4576657b4fa82e681ed9c6441c7a5cb409148a519e82d34f08680e5126c8` | [↯](https://github.com/playandprosper/i18n/releases/download/v0.0.1/i18n-arm64.exe) |

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

When reading the following table, note that I am using _shorthand notation_ for the following types.

```go
type dur time.Duration
type sec time.Second
type min time.Minute
type str string
```

| Flag | Usage |
|---|---|
| `-v` a `bool` is `false` | Show version |
| `-locales` a `bool` is `false` | Print every locale supported |
| `-db` a `str` is `i18n-db.json` | Database path for json file |
| `-to` a `str` is `<empty>` | Target locale |
| `-from` a `str` is `en_US` | Source locale |
| `-key` a `str` is `<empty>` | Translation to process |
| `-text` a `str` is `<empty>` | **CLI Mode:** Translation to process |
| `-addr` a `str` is `127.0.0.1:8888` | HTTP Daemon Process Port |
| `-force` a `bool` is `false` | Ignore cache |
| `-lm-server` a `[]str` is `<empty>` | CSV of `URL=MODEL` LM Studio Hosts |
| `-lm-url` a `str` is `http://127.0.0.1:1234/v1` | **Single:** LMStudio API URL  |
| `-lm-model` a `str` is `<empty>` | **Single:** LMStudio Model Name |
| `-lm-token` a `str` is `<empty>` | AI API Token (ignore for LMStudio) |
| `-context` a `str` is `<empty>`  | **CLI Mode:** Translation context |
| `-retries` a `int` is `1` | **CLI Mode:** Retry count before giving up |
| `-queue-size` a `int` is `8192` |  Maximum queued translations |
| `-max-retries` a `int` is `7` | Maxmimum retry attempts |
| `-shutdown-wait` a `dur` is `15 * sec` | Shutdown drain time limit |
| `-failure-pause` a `dur` is `5 * min` | Cooldown between retries |
| `-flush-interval` a `dur` is `2 * min` | DB Persistence Cadence |
| `-request-timeout` a `dur` is `90 * sec` | LMStudio Request Timeout |
| `-log` a `string` is `<empty>` | Alias for `-log-path` and `-log-dir` |
| `-log-path` a `str` is `<empty>` | File path to append new log messages |
| `-log-dir` a `str` is `<empty>` | Directory for `i18n-#.log` rotated logs |
| `-log-lines` a `int` is `3000` | Number of log lines to keep in memory |
| `-compile-audio` a `bool` is `false`  | Compile Voicebox TTS |
| `-wav-dir` a `str` is `i18n_wav` | Directory for .wav audio |
| `-mp3-dir` a `str` is `i18n_mp3` | Directory for .mp3 audio |
| `-voicebox-url` a `str` is `http://127.0.0.1:17493`  | `voicebox-server` bind address |
| `-voicebox-profile` a `str` is `<empty>`  | Voice ID to use |
| `-voicebox-engine` a `str` is `<empty>`  | Voicebox Engine to use |
| `-voicebox-token` a `str` is `<empty>`  | Voicebox API Bearer Token |
| `-audio-timeout` a `dur` is `5 * min`  | Max allowed process time per entry |
| `-audio-retries` a `int` is `3`  | Max retires for failed audio |
| `-audio-force` a `bool` is `false`  | Ignore cached audio files and regenerate |
| `-audio-strict` a `bool` is `false`  | Abort entire compile on single key failure |
| `-audio-require-language` a `bool` is `false`  | Fail for missing languages |
| `-audio-plan` a `bool` is `false`  | Print and exit audio locales for usage |
| `-voicebox-capabilities` a `bool` is `false`  | Dump voicebox capabilities and exit |
| `-audio-workers` a `int` is `1`  | Number of voicebox hosts to use |
| `-audio-background` a `bool` is `false`  | Render `.wav` in background |
| `-voicebox-server` a `[]str` is `<empty>`  | CSV of URL=PROFILE |
| `-portal` a `bool` is `true`  | Enable the HTTP Portal |
| `-portal-port` a `int` is `4444`  | Portal Launched on Port |
| `-portal-token` a `str` is `<empty>`  | Specify the password to the portal |
| `-portal-page-size` a `int` is `100`  | Items per page in Portal |
| `-portal-prune-every` a `int` is `144`  | Empty trash every #-days |
| `-transcode` a `bool` is `fase`  | Convert `.wav` to `.mp3` |
| `-ffmpeg` a `str` is `ffmpeg`  | Path to `ffmpeg` binary |
| `-mp3-bitrate` a `str` is `48k`  | Bitrate for `.mp3` files |
| `-transcode-workers` a `int` is `1`  | Concurrent ffmpeg processes |
| `-transcode-scan-interval` a `dur` is `5 * min`  | `.wav` to `.mp3` interval cooldown |
| `-transcode-failure-pause` a `dur` is `30 * min`  | Cooldown between retries |
| `-transcode-keep-wav` a `bool` is `false`  | Leave `.wav` after `.mp3` verified |

When using _dur_ or `time.Duration`, it's captured as an `int` and requires you to use `time.Duration` values.

| Human Time | Duration Value | Go Syntax |
|---|---|---|
| `1s` | `1000000000` | `1 * time.Second` |
| `5s` | `5000000000` | `5 * time.Second` |
| `10s` | `10000000000` | `10 * time.Second` |
| `15s` | `15000000000` | `15 * time.Second` |
| `20s` | `20000000000` | `20 * time.Second` |
| `25s` | `25000000000` | `25 * time.Second` |
| `30s` | `30000000000` | `30 * time.Second` |
| `35s` | `35000000000` | `35 * time.Second` |
| `40s` | `40000000000` | `40 * time.Second` |
| `45s` | `45000000000` | `45 * time.Second` |
| `50s` | `50000000000` | `50 * time.Second` |
| `55s` | `55000000000` | `55 * time.Second` |
| `60s` | `60000000000` | `60 * time.Second` |
| `90s` | `90000000000` | `90 * time.Second` |
| `1m` | `60000000000` | `1 * time.Minute` |
| `2m` | `120000000000` | `2 * time.Minute` |
| `3m` | `180000000000` | `3 * time.Minute` |
| `4m` | `240000000000` | `4 * time.Minute` |
| `5m` | `300000000000` | `5 * time.Minute` |
| `10m` | `600000000000` | `10 * time.Minute` |
| `15m` | `900000000000` | `15 * time.Minute` |
| `30m` | `1800000000000` | `30 * time.Minute` |
| `45m` | `2700000000000` | `45 * time.Minute` |
| `60m` | `3600000000000` | `60 * time.Minute` |
| `1h` | `3600000000000` | `1 * time.Hour` |
| `2h` | `7200000000000` | `2 * time.Hour` |
| `3h` | `10800000000000` | `3 * time.Hour` |
| `4h` | `14400000000000` | `4 * time.Hour` |
| `5h` | `18000000000000` | `5 * time.Hour` |
| `6h` | `21600000000000` | `6 * time.Hour` |
| `7h` | `25200000000000` | `7 * time.Hour` |
| `8h` | `28800000000000` | `8 * time.Hour` |
| `9h` | `32400000000000` | `9 * time.Hour` |
| `10h` | `36000000000000` | `10 * time.Hour` |
| `11h` | `39600000000000` | `11 * time.Hour` |
| `12h` | `43200000000000` | `12 * time.Hour` |
| `13h` | `46800000000000` | `13 * time.Hour` |
| `14h` | `50400000000000` | `14 * time.Hour` |
| `15h` | `54000000000000` | `15 * time.Hour` |
| `16h` | `57600000000000` | `16 * time.Hour` |
| `17h` | `61200000000000` | `17 * time.Hour` |
| `18h` | `64800000000000` | `18 * time.Hour` |
| `19h` | `68400000000000` | `19 * time.Hour` |
| `20h` | `72000000000000` | `20 * time.Hour` |
| `21h` | `75600000000000` | `21 * time.Hour` |
| `22h` | `79200000000000` | `22 * time.Hour` |
| `23h` | `82800000000000` | `23 * time.Hour` |
| `24h` | `86400000000000` | `24 * time.Hour` |




