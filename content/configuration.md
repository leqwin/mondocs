---
title: Advanced configuration
weight: 80
---

monbooru keeps its configuration in `/config/monbooru.toml`, created
with defaults on first start. Most settings are editable from the
Settings page and written back to the file; the few that are not
(paths, bind address, galleries' on-disk locations) need a TOML edit
and a restart.

## monbooru.toml

```toml
default_gallery = "default"      # the gallery loaded on startup

[[galleries]]                    # one block per gallery
name         = "default"
gallery_path = "/gallery"        # folder holding the source images

[server]
bind_address  = "127.0.0.1:8080"          # the shipped compose sets 0.0.0.0:8080 via env
base_url      = "http://localhost:8080"   # self-referencing links and CORS
name          = ""               # rebrand the UI; empty = monbooru
logo          = ""               # path to an image; empty = the bundled logo
custom_css    = ""               # path to a stylesheet served at /custom.css
monloader_url = ""               # browser-facing monloader URL for the footer
                                 # link; empty = monloader.api_url

[monloader]
api_url = ""                     # the monloader instance monbooru calls; set by pairing
# api_token is written by pairing; not hand-edited

[paths]
data_path  = "/data"             # databases, thumbnails, caches
model_path = "/models"           # ONNX tagger models, one subfolder each

[gallery]
watch_enabled         = true     # the filesystem watcher
max_file_size_mb      = 2048     # larger files: skipped at sync, refused at upload
default_upload_folder = ""       # where web uploads land; empty = the gallery root

[tagger]
use_cuda                   = false   # GPU inference; needs the -cuda image
parallel                   = 4       # images processed in parallel
idle_release_after_minutes = 15      # unload idle models after this long; 0 = immediately

[tagger.aggregation]
min_hit_fraction = 0.05          # frame-merge gate for videos and archives

[[tagger.taggers]]               # one block per tagger, managed from
name                 = "wd-swinv2"   # Settings -> Auto-Tagger (thresholds,
enabled              = true          # per-category caps, gallery scope)
confidence_threshold = 0.40

[auth]
enable_password       = false    # UI password, off by default
password_hash         = ""       # bcrypt hash; see Development
session_lifetime_days = 7
# [[auth.tokens]] blocks are managed by Settings -> Authentication; not hand-edited

[ui]
page_size     = 40               # images per gallery page
thumbnail_fit = "natural"        # "natural" (real aspect ratio) or "square" (cropped)

[log]
level = "warn"                   # warn / info / debug

[schedule]                       # the nightly run; see Maintenance
time                = "01:00"    # HH:MM, 24h, in the TZ timezone
sync_gallery        = true
remove_orphans      = true
run_auto_taggers    = false
find_relation_pairs = false

[relations]
default_distance      = 4        # find-pairs Hamming distance (0..12);
                                 # lower = fewer, surer pairs
default_session_order = "smallest_distance_first"  # or largest_file_first / random
incremental_on_ingest = true     # probe each new image for near-duplicates
tag_pairs             = true     # also queue pairs that share rare tags
tag_pair_threshold    = 0.85     # how strong a tag match has to be (0.5..1)
```

Most of these are edited from the Settings page. The tagger blocks are
covered in the [auto-tagger guide](guides/auto-tagger.md) and the
sections below, the schedule in
[Maintenance](guides/maintenance.md#nightly-schedule), and the
relations keys in
[Relations](guides/relations/index.md#finding-candidate-pairs).

One catch: saving **Settings -> Relations** resets
`incremental_on_ingest` to `true`. To keep the on-ingest probe off,
set it in the file and avoid re-saving that Settings section.

## Environment variables

Every variable overrides its TOML key. Pattern:
`MONBOORU_{SECTION}_{KEY}`.

| Variable | Overrides | Type |
|---|---|---|
| `MONBOORU_SERVER_BIND_ADDRESS` | `server.bind_address` | string |
| `MONBOORU_SERVER_BASE_URL` | `server.base_url` | string |
| `MONBOORU_SERVER_MONLOADER_URL` | `server.monloader_url` | string |
| `MONBOORU_MONLOADER_API_URL` | `monloader.api_url` | string |
| `MONBOORU_MONLOADER_API_TOKEN` | `monloader.api_token` | string |
| `MONBOORU_PATHS_DATA_PATH` | `paths.data_path` | string |
| `MONBOORU_PATHS_MODEL_PATH` | `paths.model_path` | string |
| `MONBOORU_GALLERY_WATCH_ENABLED` | `gallery.watch_enabled` | bool |
| `MONBOORU_GALLERY_MAX_FILE_SIZE_MB` | `gallery.max_file_size_mb` | int |
| `MONBOORU_TAGGER_USE_CUDA` | `tagger.use_cuda` | bool |
| `MONBOORU_AUTH_ENABLE_PASSWORD` | `auth.enable_password` | bool |
| `MONBOORU_AUTH_PASSWORD_HASH` | `auth.password_hash` | string |
| `MONBOORU_AUTH_SESSION_LIFETIME_DAYS` | `auth.session_lifetime_days` | int |
| `MONBOORU_LOG_LEVEL` | `log.level` | `warn` / `info` / `debug` |

Per-tagger settings (enable, thresholds, worker count) live in the
Settings UI only, not in env vars.

A few more variables affect runtime behavior without overriding a
TOML key:

| Variable | Effect |
|---|---|
| `TZ` | Timezone name (e.g. `Etc/UTC`) for displayed timestamps and the daily schedule. Defaults to `UTC`. |
| `MONBOORU_TAGGER_BACKEND` | Set to `inproc` to run tagger inference inside the main process instead of the default subprocess. See below. |
| `MONBOORU_TAGGER_WORKER_LOG` | Log level for the `tagger-worker` subprocess only; same `warn` / `info` / `debug` values. Read once when the worker starts. |

ONNX Runtime and CUDA also honor their standard variables:

| Variable | Effect |
|---|---|
| `ORT_LIB_PATH` | Absolute path to `libonnxruntime.so` when the library is not on `LD_LIBRARY_PATH` / `/usr/lib`. Only consulted by a from-source `-tags tagger` build; the Docker image bundles ORT. |
| `CUDA_CACHE_PATH` | Directory for the cuDNN JIT cache. With `tagger.use_cuda = true`, monbooru defaults this to `<data_path>/.nv-cache/` so the cache survives container recycles. |

## The Settings page: General

The everyday settings live in **Settings -> General** rather than the
config file:

- **Max file size** for ingest and upload (default 2048 MB, up to
  5120). Large comic archives are what need the headroom.
- **Default upload folder** - where browser uploads land in the
  gallery.
- **Watch folder** - the filesystem watcher on/off. Saving takes the
  setting straight away, but the watcher itself only starts when
  monbooru does, so restart after switching it on.
- **Page size** - images per gallery page (default 40).
- **Thumbnails** - square (cropped) or real aspect ratio.

## Custom CSS

Drop a `custom.css` next to `monbooru.toml` and set
`custom_css = "/config/custom.css"` under `[server]` to load an extra
stylesheet. The path must sit under the config directory, `/config`,
or `/data`; anything outside that allowlist is logged at startup and
ignored. The file is served at `/custom.css` and linked after the
bundled stylesheet, so a `:root` block in it wins the cascade and you
can retheme without rebuilding.

## Custom name and logo

Optional keys under `[server]`:

```toml
[server]
name = "monbooru"
logo = "/config/logo.png"
```

`name` replaces the wordmark, every page title, and the login heading.
The CSS uppercases the wordmark regardless of case. Missing or empty
falls back to `Monbooru`.

`logo` is an absolute path to an image file (PNG works; anything the
browser renders is fine). When set, it is used as both the favicon and
the topbar logo. Missing or empty falls back to the bundled defaults.

## Log levels

`log.level` (or `MONBOORU_LOG_LEVEL`):

- `warn` (default): warnings, errors, and failed or rate-limited
  logins.
- `info`: adds one line per non-noisy HTTP request, startup banners,
  and explicit mutations (successful logins, settings changes).
- `debug`: adds static asset, thumbnail, health and status-poll hits.

## GPU (CUDA)

The default image is CPU-only. For GPU inference, switch to the
`-cuda` image tag, pass the GPU into the container the usual way (the
compose file has a commented example), then enable
**Settings -> Auto-Tagger -> Use GPU (CUDA)** (or set
`MONBOORU_TAGGER_USE_CUDA=true`). GPU makes batch auto-tagging a lot
faster. The current mode shows as a badge in Settings, and the save is
rejected with an inline error when no CUDA runtime or GPU device is
actually reachable.

Worker count is set from **Settings -> Auto-Tagger** or
`tagger.parallel` in TOML (default 4). On GPU, raise it if CPU-side
image preprocessing becomes the bottleneck.

The very first GPU inference on a new host pays a one-time JIT
compilation cost of a few minutes. The compiled kernels are cached
under `<data_path>/.nv-cache/` so later restarts load quickly; keep
the data path on a persistent volume, or point `CUDA_CACHE_PATH`
somewhere that is.

## Custom ONNX models

Beyond the catalog taggers, other ONNX tagging models may or may not
work. Drop the model into its own subfolder under the `models` volume.
Each subfolder needs:

- `model.onnx` - the weights.
- One label file: `tags.csv` (WD14 schema: `tag_id,name,category_id`),
  `tags.txt` (one label per line, all `general`), or a Camie-style
  metadata `.json`.

Reload the Settings page and the new tagger appears in the table.

monbooru auto-detects how to run the model only for `.csv` (WD14) and
`.txt` (JoyTag) label files. A Camie-style `.json` needs a
`tagger.json` sidecar next to `model.onnx` declaring at least
`label_format` and `category_scheme`, unless the subfolder is named
after a built-in catalog entry. Use the same sidecar for any model
whose preprocessing monbooru cannot infer - input size, channel order,
normalization, padding, output activation - it overlays the
auto-detected profile. The repository's
`internal/tagger/profile_default/` folder has examples.

## Label dispatch (dispatch.json)

Drop a `dispatch.json` next to a tagger's `model.onnx` to remap a
label to another category, rename it, or drop it entirely. monbooru
ships defaults for the catalog taggers
(`internal/tagger/dispatch_default/<tagger>.json` in the repository);
your file overlays them.

```json
{
  "version": 1,
  "rules": [
    { "source": "monochrome",       "category": "medium" },
    { "source": "artist_name",      "category": "meta"   },
    { "source": "ugly_label",       "category": ""       },
    { "source": "twitter_username", "category": "meta", "name": "twitter" }
  ]
}
```

- `source` matches the raw label the model emits.
- `category` is the destination category. An empty string drops the
  label entirely.
- `name` (optional) renames the tag on insertion; empty keeps the
  source name. Renames are validated against the tag-name rules.

Same-source entries replace the shipped default, new sources append.
A rule pointing at a category that does not exist on the gallery is
skipped and the shipped default for that source survives.

## Tagger memory and backend

Models stay loaded for 15 minutes after the last run, then unload to
free RAM (and VRAM on GPU). Tune via **Settings -> Auto-Tagger ->
Tagger RAM/VRAM idle release (minutes)** or
`tagger.idle_release_after_minutes` in TOML; `0` releases immediately
after every run.

By default inference runs in a supervised subprocess
(`tagger-worker`); idle release terminates it so the OS reclaims
everything, including the CUDA libraries. Its memory shows in
**Settings -> Stats**. To run inference inside the main process
instead, set `MONBOORU_TAGGER_BACKEND=inproc` before launch - a
fallback for subprocess problems, not the supported default.

## Frame-merge gate (videos and archives)

When a tagger runs on a multi-frame item (a video's 5 sampled frames,
an archive's pages), per-frame results merge into one tag set; a
label must hit on several frames to survive. The
`tagger.aggregation.min_hit_fraction` TOML knob (default `0.05`)
controls the required fraction of frames, clamped between 2 and 10
frames. Set it to `0` to revert to "any single hit wins". Static
images are unaffected. See the
[auto-tagger guide](guides/auto-tagger.md#videos-and-archives) for the
user-facing behavior.
