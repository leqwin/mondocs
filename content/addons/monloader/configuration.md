---
title: Advanced configuration
weight: 80
---

monloader keeps its configuration in `/config/monloader.toml`, written with
defaults on first run. The Settings page edits the same values where that is
safe at runtime; the override tables and a few server keys are file-only.

## monloader.toml

```toml
[server]
bind_address = "0.0.0.0:8081"
base_url     = "http://localhost:8081"   # the address monloader advertises when pairing
name         = ""                        # rebrand the UI; empty = monloader
logo         = ""                        # path to an image; empty = the bundled logo
custom_css   = ""                        # path to a stylesheet served at /custom.css

[monbooru]
api_url         = "http://monbooru:8080" # the monbooru instance
api_token       = ""                     # set by pairing, or by hand for a manual setup
web_url         = ""                     # browser-facing monbooru base for links; blank =
                                         # api_url for image links, monbooru link hidden
default_gallery = ""                     # blank = monbooru's active gallery
paused          = false                  # set by the footer light; holds the link without unpairing

[downloader]
concurrency            = 1               # worker goroutines; applies on restart
max_items_per_job      = 200             # per-job cap on a bulk search
default_folder         = "downloads"     # monbooru subfolder for pushed files
history_retention_days = 7               # drop finished downloads from the queue
                                         # after this many days; 0 keeps them

[gallerydl]
binary_path   = "gallery-dl"
config_path   = "/config/gallery-dl.json"          # managed file the app writes
archive_path  = "/config/gallery-dl-archive.sqlite"
cookies_dir   = "/config/cookies"                  # per-site cookies files
sleep_request = 1.0                      # seconds between requests (politeness)
raw_config    = ""                       # optional JSON merged into the managed config

[auth]
enable_password       = false            # UI password, off by default
password_hash         = ""               # bcrypt hash; see API and development
session_lifetime_days = 7

[log]
level = "warn"                           # warn / info / debug

[ptr]                                    # the optional Hydrus PTR index
enabled     = false
data_path   = "/ptr"
address     = "https://ptr.hydrus.network:45871"
access_key  = ""                         # empty = the PTR's public read-only key
fetch_sleep = 1.0
min_free_gb = 70

[lookup]                                 # the lookup chain's similarity stage
min_similarity = 80                      # percent; candidates below are ignored

[lookup.iqdb]
order = 2                                # chain position; uses the danbooru site credentials

[lookup.saucenao]
order   = 3
api_key = ""                             # from saucenao.com account settings

[[sites]]                                # one block per configured site
name         = "gelbooru"                # gallery-dl category
username     = ""                        # danbooru / e621 families
api_key      = ""
user_id      = ""                        # gelbooru family
gallery      = ""                        # per-source target; empty = default_gallery
cookies      = ""                        # cookies file name under cookies_dir
lookup_order = 4                         # lookup-chain position; 0 or absent = not queried
```

Most of these are edited from the Settings page; note that the downloads
section there also carries the "sleep / request" field, which writes
`gallerydl.sleep_request`.

Two more repeatable tables, `[[tag_overrides]]` and `[[rating_overrides]]`,
reroute a site's tag categories and rating values; they are covered in
[metadata mapping](guides/mapping.md). The `[ptr]` block is covered in
[Hydrus PTR](guides/ptr/index.md), the lookup chain and `[[sites]]` in
[reverse lookup](guides/lookup/index.md) and [sites](guides/sites/index.md).

## Environment variables

Environment variables override the TOML on the pattern
`MONLOADER_{SECTION}_{KEY}`:

| Variable | Overrides | Type |
|---|---|---|
| `MONLOADER_SERVER_BIND_ADDRESS` | `server.bind_address` | string |
| `MONLOADER_SERVER_BASE_URL` | `server.base_url` | string |
| `MONLOADER_MONBOORU_API_URL` | `monbooru.api_url` | string |
| `MONLOADER_MONBOORU_API_TOKEN` | `monbooru.api_token` | string |
| `MONLOADER_MONBOORU_WEB_URL` | `monbooru.web_url` | string |
| `MONLOADER_MONBOORU_DEFAULT_GALLERY` | `monbooru.default_gallery` | string |
| `MONLOADER_DOWNLOADER_CONCURRENCY` | `downloader.concurrency` | int |
| `MONLOADER_DOWNLOADER_MAX_ITEMS_PER_JOB` | `downloader.max_items_per_job` | int |
| `MONLOADER_DOWNLOADER_DEFAULT_FOLDER` | `downloader.default_folder` | string |
| `MONLOADER_DOWNLOADER_HISTORY_RETENTION_DAYS` | `downloader.history_retention_days` | int |
| `MONLOADER_GALLERYDL_BINARY_PATH` | `gallerydl.binary_path` | string |
| `MONLOADER_GALLERYDL_CONFIG_PATH` | `gallerydl.config_path` | string |
| `MONLOADER_GALLERYDL_ARCHIVE_PATH` | `gallerydl.archive_path` | string |
| `MONLOADER_GALLERYDL_COOKIES_DIR` | `gallerydl.cookies_dir` | string |
| `MONLOADER_GALLERYDL_SLEEP_REQUEST` | `gallerydl.sleep_request` | float |
| `MONLOADER_AUTH_ENABLE_PASSWORD` | `auth.enable_password` | bool |
| `MONLOADER_AUTH_PASSWORD_HASH` | `auth.password_hash` | string |
| `MONLOADER_LOG_LEVEL` | `log.level` | `warn` / `info` / `debug` |
| `MONLOADER_PTR_ENABLED` | `ptr.enabled` | bool |
| `MONLOADER_PTR_DATA_PATH` | `ptr.data_path` | string |
| `MONLOADER_PTR_ADDRESS` | `ptr.address` | string |
| `MONLOADER_PTR_ACCESS_KEY` | `ptr.access_key` | string |
| `MONLOADER_PTR_FETCH_SLEEP` | `ptr.fetch_sleep` | float |
| `MONLOADER_PTR_MIN_FREE_GB` | `ptr.min_free_gb` | int |
| `MONLOADER_LOOKUP_MIN_SIMILARITY` | `lookup.min_similarity` | int |
| `MONLOADER_LOOKUP_SAUCENAO_API_KEY` | `lookup.saucenao.api_key` | string |

One more variable affects runtime behavior without overriding a TOML
key:

| Variable | Effect |
|---|---|
| `TZ` | Timezone name (default `UTC`) for displayed timestamps. Any IANA name works. |

## Raw gallery-dl passthrough

The **advanced** section of the Settings page has a raw gallery-dl config
textarea: a JSON object merged into the managed `gallery-dl.json` last, so
your keys win. Invalid JSON is rejected at save and never written. This is
the escape hatch for gallery-dl options monloader does not manage itself.

## Custom CSS

Set `custom_css` in `[server]` to a file path and monloader serves it at
`/custom.css`, linked after the bundled stylesheet, so a `:root` block there
wins the cascade. One custom stylesheet can theme monbooru and monloader
together.

## Logo and title

`name` and `logo` in `[server]` rebrand the UI without a rebuild. `name`
replaces the wordmark, every page title, and the login heading; the CSS
uppercases the wordmark, so `myloader` renders as `MYLOADER`. Empty falls
back to `monloader`. `logo` is a path to an image served at `/custom.logo`
and used for both the favicon and the logo; empty falls back to the bundled
assets.

## Log levels

`log.level`:

- `warn` (default) - warnings, errors, and explicit mutations (logins,
  settings saves).
- `info` - adds one line per non-noisy HTTP request and the startup banner
  (gallery-dl version, extractor count, work dir).
- `debug` - adds the 2-second queue poll, the connectivity-light check, and
  `/health` hits.

## The stats block

The Settings page ends with a read-only stats section: process memory
(RSS, Go heap, goroutines), the bundled gallery-dl version and extractor
count, and the queue's worker/queued/running/finished counters. Nothing
there is configurable; it exists so you can check the process's health
without leaving the UI.
