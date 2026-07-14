---
title: Install
weight: 10
---

## Quick start (Docker)

1. Grab `docker/docker-compose.yml` from the monbooru repository and
   edit the volume paths so `/gallery`, `/data`, `/config` and
   `/models` map to host folders you control.
2. `docker compose up -d`
3. Open `http://localhost:8080`.

On first start monbooru creates a config file with defaults at
`/config/monbooru.toml`. Most settings are editable from the Settings
page in the UI; the few that are not (paths, bind address) need a TOML
edit and a restart. The full reference is in
[Configuration](../configuration.md).

A gallery is a named folder full of images. The default one points at
`/gallery`. Drop a file under that path and the watcher picks it up
within a few seconds; if the watcher is off, click the sync
icon at the top right to walk the folder in one pass.

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
`GET /health`, which returns `{"status":"ok","version":"..."}`.

## Next

Head to [First steps](first-steps/index.md) to add your first images. For
environment variables, custom CSS, a custom name and logo, GPU setup
and log levels, see [Configuration](../configuration.md).
