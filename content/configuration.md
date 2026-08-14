---
title: Advanced configuration
weight: 80
---

monbooru keeps its configuration in `/config/monbooru.toml`, created
with defaults on first start. Most settings are editable from the
Settings page and written back to the file; the few that are not
(paths, bind address, galleries' on-disk locations) need a TOML edit
and a restart.

Anything saved from the Settings page rewrites the whole file from
monbooru's own view of it, so comments and hand-arranged ordering will not survive.

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
theme         = ""               # name of a folder (or .css) in <configdir>/themes/
theme_color   = ""               # install splash + address bar; empty = the bundled dark
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
execution_provider         = "cpu"   # cpu / cuda / directml / tensorrt / openvino / coreml / coremlv2
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
tag_pair_threshold    = 0.85     # how strong a tag match has to be (0.7..1;
                                 # the settings page shows it as a percent)
```

Most of these are edited from the Settings page. The tagger blocks are
covered in the [auto-tagger guide](guides/auto-tagger/index.md) and the
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
| `MONBOORU_TAGGER_EXECUTION_PROVIDER` | `tagger.execution_provider` | `cpu` / `cuda` / `directml` / `tensorrt` / `openvino` / `coreml` / `coremlv2` |
| `MONBOORU_TAGGER_USE_CUDA` | `tagger.execution_provider` | bool; older alias, `true` means `cuda` unless the variable above is set |
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
| `MONBOORU_TAGGER_DIRECTML_DEVICE_ID` | Which GPU DirectML runs on, as an adapter number. Defaults to `0`, the primary one; only useful on a machine with more than one GPU. |

ONNX Runtime and CUDA also honor their standard variables:

| Variable | Effect |
|---|---|
| `ORT_LIB_PATH` | Absolute path to `libonnxruntime.so` when the library is not on `LD_LIBRARY_PATH` / `/usr/lib`. Only consulted by a from-source `-tags tagger` build; the Docker image bundles ORT. |
| `CUDA_CACHE_PATH` | Directory for the cuDNN JIT cache. With the `cuda` provider, monbooru defaults this to `<data_path>/.nv-cache/` so the cache survives container recycles. |

## The Settings page: General

The everyday settings (max file size, default upload folder, watch
folder, page size, thumbnail style) live in **Settings -> General**
rather than the config file. Two non-obvious points: max file size
goes up to 5120 MB - large comic archives are what need the
headroom - and the watcher itself only starts when monbooru does, so
restart after switching it on.

## Themes

A theme is a folder you drop in `themes/`, next to `monbooru.toml`,
holding a `theme.css`:

```
/config/themes/light/theme.css
/config/themes/light/logo.png   # optional
```

Pick it under **Settings -> Plugins**. It applies at once, with no
restart, and the choice is remembered. A theme that ships a `logo.png`
swaps the topbar logo along with the colours; the tab icon keeps the
shipped one unless you set `server.logo`, which outranks any theme on
both. 

See [monbooru-plugins registry](https://github.com/monbooru/monbooru-plugins).

Every colour and the font come from one `:root` block, so a whole theme
is that block and nothing else. A light one, top to bottom:

```css
:root {
  color-scheme: light;
  --bg:         #f4f1ee;   /* the page */
  --bg-surface: #e6e0da;   /* top bar, sidebar, panels, dialogs */
  --bg-input:   #ffffff;   /* text fields */
  --border:     #c8bfb6;   /* every rule and outline */
  --fg:         #1c1a19;   /* text */
  --fg-dim:     #6b625c;   /* secondary text */
  --accent:     #9d2235;   /* focus rings, the selected image, delete buttons */
  --link:       #8a1f30;
  --success:    #2f7a4d;
  --warning:    #8a6a10;
  --error:      #b02a37;
  --monloader:  #2f5d8a;   /* the monloader actions */
  --tagger:     #1f6f63;   /* the auto-tagger */
  --plugin:     #7a3fa0;   /* plugin buttons and the blocks holding them */
  --fav:        #c0392b;   /* favorites */
  --remove:     #a03a44;   /* tag remove buttons */
  --alternate:  #4f45a0;   /* the Variant button in a relations review */
  --scrim:      #ffffff;   /* badges and pills over images, dialog backdrops */
  --media-bg:   #ffffff;   /* behind an image that doesn't fill its frame */
  --font-mono:  "IBM Plex Mono", monospace;
}
```

The top menu takes an optional colour per entry:

```css
:root {
  --nav-images:      #b12937;
  --nav-inbox:       #8f4c1b;
  --nav-categories:  #755a0d;
  --nav-tags:        #226c3a;
  --nav-collections: #136a64;
  --nav-relations:   #1e6393;
  --nav-settings:    #813cb5;
}
```

Tag category colours are library data (you set them on the Categories page); but a theme can recolor the default ones monbooru ships.  
Each variable is named after the colour it replaces:

```css
:root {
  --cat-3d90e3: #2b5ea4;   /* general   */
  --cat-00aa00: #226c3a;   /* character */
  --cat-cc0000: #b12937;   /* artist    */
  --cat-aa00aa: #883aac;   /* copyright */
  --cat-ffaa00: #7a580e;   /* meta      */
  --cat-996666: #82505b;   /* rating    */
  --cat-7d4fbf: #6945c4;   /* medium    */
  --cat-b85c9e: #983a7d;   /* person    */
  --cat-4a8fa8: #2b657b;   /* year      */
  --cat-ed5d1f: #944923;   /* species   */
}
```

`color-scheme` tells the browser which way
to paint the parts monbooru leaves alone - scrollbars, dropdown lists,
autofilled fields. Without it a light theme keeps dark scrollbars on a
pale page.

## Custom CSS

`custom_css = "/config/custom.css"` under `[server]` loads one more
stylesheet, after any theme, so you can your own editing to a theme you downloaded. The path must sit under the config
directory, `/config`, or `/data`.

One thing a stylesheet cannot reach: the install splash and the mobile address bar come from the web manifest. Set `theme_color` under
`[server]` to your `--bg` so an installed monbooru opens on the right colour.

## Custom name and logo

Optional keys under `[server]`:

```toml
[server]
name = "monbooru"
logo = "/config/logo.png"
```

`name` replaces the wordmark, every page title, and the login heading
(the CSS uppercases the wordmark regardless of case). `logo` is an
absolute path to an image file (anything the browser renders), used
as both the favicon and the topbar logo. Missing or empty values fall
back to the bundled defaults.

## Log levels

`log.level` (or `MONBOORU_LOG_LEVEL`):

- `warn` (default): warnings, errors, and failed or rate-limited
  logins.
- `info`: adds one line per non-noisy HTTP request, startup banners,
  and explicit mutations (successful logins, settings changes).
- `debug`: adds static asset, thumbnail, health and status-poll hits.

## GPU and other execution providers

Inference runs on the CPU by default. To speed up batch auto-tagging
with a GPU, pick an execution provider under
**Settings -> Auto-Tagger -> Execution provider** (or set
`tagger.execution_provider` in TOML): `cuda` for NVIDIA, `directml`
for GPUs on Windows, `tensorrt` for NVIDIA with TensorRT, `openvino`
for Intel GPUs, `coreml` or `coremlv2` on Apple hardware. The save is
rejected with an inline error when the provider's ONNX Runtime
library or device is not actually reachable. Configs from older
versions that set `use_cuda = true` are read as `cuda` automatically.

On Docker, the default image is CPU-only: for CUDA, switch to the
`-cuda` image tag and pass the GPU into the container the usual way
(the compose file has a commented example). That tag is amd64 only.

Worker count is set from **Settings -> Auto-Tagger** or
`tagger.parallel` in TOML (default 4). On GPU, raise it if CPU-side
image preprocessing becomes the bottleneck. DirectML is the exception:
it can only tag one image at a time, so it ignores the setting.

The very first GPU inference on a new host pays a one-time JIT
compilation cost of a few minutes. The compiled kernels are cached
under `<data_path>/` (`.nv-cache/` for CUDA, `.openvino-cache/` for
OpenVINO) so later restarts load quickly; keep the data path on a
persistent volume, or point `CUDA_CACHE_PATH` somewhere that is.

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

A `dispatch.json` next to a tagger's `model.onnx` remaps a label to
another category, renames it, or drops it entirely. monbooru ships
defaults for the catalog taggers
(`internal/tagger/dispatch_default/<tagger>.json` in the repository);
your file overlays them. The usual way to edit it is the mappings tab
of the tagger's Configure dialog (see the
[auto-tagger guide](guides/auto-tagger/index.md#mappings)), which writes
this file for you and drops any rule that just restates a shipped
default; the format below is for editing by hand or sharing.

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
everything, including the GPU libraries. To run inference inside the
main process instead, set `MONBOORU_TAGGER_BACKEND=inproc` before
launch - a fallback for subprocess problems, not the supported
default.

## Frame-merge gate (videos and archives)

When a tagger runs on a multi-frame item (a video's 5 sampled frames,
an archive's pages), per-frame results merge into one tag set; a
label must hit on several frames to survive. The
`tagger.aggregation.min_hit_fraction` TOML knob (default `0.05`)
controls the required fraction of frames, clamped between 2 and 10
frames. Set it to `0` to revert to "any single hit wins". Static
images are unaffected. See the
[auto-tagger guide](guides/auto-tagger/index.md#videos-and-archives) for the
user-facing behavior.
