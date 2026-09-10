# Sponsor i18n

The **i18n** product is being built to support philanthropic efforts of [Play and Prosper](https://playandprospertherapy.com/). This product was built to provide information resources to patients around the world in a localized and accessible manner. 

- 📦 Repository 👉🏻 https://github.com/playandprosper/i18n 🔒
- 🔓 Unlock 👉🏻 https://github.com/sponsors/andreimerlescu 🤩

**i18n** is a universal application written in _Go_ that provides an internationalization and localization daemon that a web application can consume to provide translations in dozens of languages using AI. The application does not run AI for every request. It caches translated keys and provides hot cache access to those keys. It has the ability to render text and audio translations.

The **i18n** application is used in conjunction with the [php-avc](https://github.com/playandprosper/sponsor-avc) Model View Controller framework. It is compatible with **Ruby on Rails** and other `i18n` components. In fact, [php-avc](https://github.com/playandprosper/sponsor-avc) has a customized `i18n.php` helper script that interfaces with the engine itself, to provide an easier templating experience to the PHP framework. In Ruby, the [i18n-rubygem](https://github.com/playandprosper/i18n-rubygem) package is designed to provide that `i18n.php` interface into the **i18n** binary to the Rails framework. You can bring the **i18n** binary to any front end system. It's a basic HTTP GET request to `127.0.0.1:8888/en_US?key=&text=&context=` in order to get back the translated value. You can also hit `127.0.0.1:8888/meta?key=<key>` to extract data points like `language`, `country`, `currency`, `flag`, `bcp`, `capitol`, `tz`, `short`. Replace `<key>` with any one of them and the body of the request contains the value of the metadata property itself. The `flag` returns with a literal emoji like `🇺🇸`.

By sponsoring the repository, you're not buying a copy of the source code for ownership. You're being granted a limited use license under BUSL 1.1 until it becomes open source on 11/11/2033. Without sponsorship, permission to run and use the binary is prohibited. To begin using **i18n** in _any capacity_ please select the $666/mo option here 👉🏻 https://github.com/sponsors/andreimerlescu. Sponsorship grants you read-only access to the _source code_ of i18n and it unlocks the binary download links below.

Now, let me show you what you're sponsoring! When you see it live on the [Play and Prosper](https://playandprospertherapy.com/) website, it'll sell itself, but until that day arrives, this page will have to do until then. 

## Installation

Once you've unlocked the repository, these links will work. If you're not signed into GitHub or you haven't sponsored the developer yet, you'll see a 404 Not Found error on each of these links.

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

The **i18n** binary is split into 4 components: 

1. HTTP2 Daemon `:8888` 👉🏻 Frontend Frameworks ( like [php-avc](https://github.com/playandprosper/sponsor-avc) )
2. HTTP Portal `:4444` 👉🏻 Runtime GUI + Monitor
3. `-compile-audio` mode performs TTS using [voicebox](https://github.com/jamiepine/voicebox)-server generating `.wav` files
4. `-transcode` mode compresses `.wav` files into `.mp3` files

The entire runtime of the binary is controlled by the following flags. You read the first cell literally as `<flag>` a `<type>` is `<default>` where I am using _shorthand_ notation for `time.Duration`, `time.Second`, `time.Minute`, and `string` Go types.

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

| Human Time | `time.Duration` Value | Go Syntax |
|---|---|---|
| `15s` | `15000000000` | `15 * time.Second` |
| `90s` | `90000000000` | `90 * time.Second` |
| `2m` | `120000000000` | `2 * time.Minute` |
| `5m` | `300000000000` | `5 * time.Minute` |
| `30m` | `1800000000000` | `30 * time.Minute` |

For a more detailed look into `time.Duration` to `int` conversions for `flag.Duration` usage in Go, please see [this gist](https://gist.github.com/andreimerlescu/2c15535e22b5d0b3ba8141a1ecb8b98b).

## PHP Usage

The `i18n.php` file has the following header signature:

```php
<?php declare(strict_types=1);
namespace AVC;

require_once __DIR__ . '/router.php';
require_once __DIR__ . '/html.php';

final class i18n
{

    public static string $locale = LOCALE_UNITED_STATES['code'];
    public static string $sourceLocale = LOCALE_UNITED_STATES['code'];
    public static string $service = 'http://127.0.0.1:8888';
    public static int $connectTimeoutMs = 5;
    public static int $timeoutMs = 25;
    public static ?HTML $html = null;

    #[\NoDiscard]
    public static function __(
        string $text,
        ?bool $raw = null,
        string|array $icon = "",
        string $place = "left",
        string|array $classes = [],
    ): string {}

    public static function possessive(
        string $string,
        ?string $locale = null
    ): string {}

    #[\NoDiscard]
    public static function gettext(string $text): string {}

    #[\NoDiscard]
    public static function html(): ?HTML {}

    public static function browserLocale(): string {}

    public static function findLocale(): string {}
}

\class_alias(i18n::class, 'i18n');
```

Based on building out [Play and Prosper](https://playandprospertherapy.com/) website, it's probably best for you to see how the various components were built out with **i18n** through template usage examples: 

An individual dropdown navbar menu from [bootstrap](https://getbootstrap.com) can be rendered using the i18n PHP helper script.

**application/views/global/_footer.phtml**

```php
<?php declare(strict_types=1);
// set this for use with Render::string()
global $__li_class;
global $__a_class;
global $__hide_header;
global $__br_on_header;
$__li_class = "";
$__a_class = "dropdown-item";
$__hide_header = false;
$__br_on_header = false;

echo HTML::build()->tag(
  tagName: "li",
  classes: ["nav-item", "dropdown"],
  contents: implode("\n", [
    i18n::html()->a(
      href: "#",
      title: "Resources", // this gets injected into i18n for translation and relies on i18n::$locale 
      classes: "nav-link dropdown-toggle",
      extra: "role=\"button\" data-bs-toggle=\"dropdown\" aria-expanded=\"false\"",
      active: Render::if_action_in_controller(
        controller: "section",
        actions: ["item1", "item2"],
      ),
      icon: "bi-book-half", // uses bootstrap icons https://icons.getbootstrap.com/
    ),
    HTML::build()->tag(
      tagName: "ul",
      classes: "dropdown-menu",
      contents: Render::string("menu", "_section_items"),
    ),
  ]),
);
```

**application/views/menu/_section_items.phtml**

```phtml
<?php declare(strict_types=1);

global $__li_class;
global $__a_class;
global $__hide_header;
global $__br_on_header;

$__li_class ??= "";
$__a_class ??= "dropdown-item";
$__hide_header ??= false;
$__br_on_header ??= false;

if(!$__hide_header){
  echo HTML::build()->tag(
    tagName: "li",
    contents: HTML::build()->tag(
      tagName: "h6",
      classes: ["dropdown-header", "text-primary"],
      contents: "Translated Dropdown Header Title",
    ),
  );
}

if(true === $__br_on_header) echo "</ol><ol class='breadcrumb'>\n";

// prints <li><a href="#" class="active">First Link</a></li>
echo HTML::build()->tag(
  tagName: "li",
  classes: [$__li_class],
  contents: i18n::html()->a(
        href: "#",
        title: "First Link",
        classes: $__a_class,
        active: Render::if_controller_action(
            controller: "section",
            action: "link1",
        ),
        icon: "bi-1-circle",
    )
);

// prints <li><a href="#" class=" ">Second Link</a></li>
echo HTML::build()->tag(
  tagName: "li",
  classes: [$__li_class],
  contents: i18n::html()->a(
        href: "#",
        title: "Second Link",
        classes: $__a_class,
        active: Render::if_controller_action(
            controller: "section",
            action: "link2",
        ),
        icon: "bi-2-circle",
    )
);
```

If you don't want your code to look like that, you don't have to! You can also use classic template styles too.

```phtml
<html>
<head>
  <title><?= i18n::__("This is the site title translated into dozens of languages"); ?></title>
</head>
<body>
  <div>
    <h1><?= i18n::__("My Website Title"); ?></h1>
    <p><?= i18n::__("You can safely use this syntax hundreds of per times per page load with little to no impact on performance."); ?></p>
  </div>
</body>
</html>
```

## Thank You!

Thank you for using **i18n** and for choosing to sponsor the development of this piece of globalization technology.


