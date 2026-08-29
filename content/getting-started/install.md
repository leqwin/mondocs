---
title: Install
weight: 10
---

## Quick start (Docker)

1. Grab [`docker/docker-compose.yml`](https://github.com/monbooru/monbooru/blob/main/docker/docker-compose.yml) from the monbooru repository and
   edit the volume paths so `/gallery`, `/data`, `/config` and
   `/models` map to your folders.
2. `docker compose up -d`
3. Open `http://localhost:8455`.

On first start monbooru creates a config file with defaults at
`/config/monbooru.toml`. Most settings are editable from the Settings
page in the UI; the few that are not (paths, bind address) need a TOML
edit and a restart. The full reference is in
[Configuration](../configuration.md).

A gallery is a named folder full of images; the default one points at
`/gallery`.

The compose file also contains an optional `monloader` service, the
companion that handles downloading and reverse lookup. You can ignore
it to start with and add it later; see the
[monloader install page](../addons/monloader/getting-started/install.md).

## Volumes

| Mount | Purpose |
|---|---|
| `/gallery` | Your source images |
| `/data` | SQLite database and thumbnails |
| `/config` | `monbooru.toml` |
| `/models` | ONNX auto-tagger models, one subfolder per tagger |

Keep `/data` on a persistent volume: it holds everything monbooru
derives from your files (database, thumbnails, caches). The images
themselves only ever live under `/gallery`.

## Permissions (non-root)

The image runs as a non-root user. The bundled compose file sets
`user: "1000:1000"`, which matches the common first user on a Linux
host; edit it to your own uid:gid. Files written to `/gallery`,
`/data` and `/config` then land owned by you, and the bind mounts stay
readable and writable. Make sure those host directories are owned by,
or accessible to, that uid.

The compose file also drops all container capabilities and adds back
only `CHOWN` and `DAC_OVERRIDE`, which monbooru needs to take
ownership of files at ingest so it can move or delete them later. If
every file in your gallery is already owned by the uid the container
runs as, you can drop those two as well.

## Healthcheck

The Docker image has a built-in healthcheck: the
`monbooru healthcheck` subcommand probes the local `/health` endpoint
and exits 0 when the server answers. `docker ps` shows the container
as `healthy` once the app is up; you can point your own monitoring at
`GET /health`, which returns `{"app":"monbooru","status":"ok","version":"..."}`.

## Quick start (desktop)

Download a **desktop** build for your system from the
[releases page](https://github.com/monbooru/monbooru/releases), unpack it,
and run it. A browser opens on a short setup page.

Downloads come on two axes, and the filename says which is which:

| Axis | What you get |
|---|---|
| desktop or server | **desktop** opens automatically in a browser, keeps its files where your system puts a user's files. **server** keeps the defaults meant for a machine you run it on and reach from elsewhere. |
| lite or bundled | **lite** is one binary. Video thumbnails need ffmpeg installed yourself; auto-tagging needs ONNX Runtime. **bundled** adds ffmpeg and the ONNX Runtime, so video previews and local auto-tagging work out of the box. |

On Windows each desktop build also ships as an installer, which is the
same files plus Start Menu and desktop shortcuts; on Linux the Flatpak is
the desktop bundled build inside a sandbox.

### Where your files go

| | Linux | Windows |
|---|---|---|
| Settings, plugins, themes | `~/.config/monbooru` | `%AppData%\monbooru` |
| Database and thumbnails | `~/.local/share/monbooru` | `%LocalAppData%\monbooru` |
| Log file | `<database folder>/logs` | `<database folder>\logs` |
| Your images | wherever you pointed setup | same |

A Flatpak install keeps its own copies of the first three under
`~/.var/app/io.github.monbooru.Monbooru/`. 

If you put a `monbooru.toml` next to the program before starting it,
monbooru uses that one and keeps its database in a `data` folder beside it
too. That makes the whole install portable.

## Next

Head to [First steps](first-steps/index.md) to add your first images. For
environment variables, custom CSS, a custom name and logo, GPU setup
and log levels, see [Configuration](../configuration.md).
