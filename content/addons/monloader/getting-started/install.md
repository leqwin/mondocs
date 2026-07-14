---
title: Install
weight: 10
---

monloader runs as a container next to monbooru. It needs a monbooru
instance to push into; nothing else is required to start. To bring up the
whole stack from scratch, see the
[quick start](../../quick-start.md).

## Quick start

monloader ships as a commented-out service in monbooru's
`docker/docker-compose.yml`, so enabling it there puts the two containers on
one network with no extra wiring.

1. Uncomment the `monloader` service in monbooru's compose file and start
   it:

   ```bash
   docker compose up -d monloader
   ```

2. Open `http://localhost:8081`. The shipped compose publishes the port on
   `127.0.0.1` only; to reach monloader from another machine on your
   network, adjust the `ports:` line.
3. Pair it with monbooru: see [pairing](pairing/index.md). Approving the
   request issues the API tokens automatically.
4. In monloader's settings, pick a **default gallery** and save.
5. Paste a URL into the command bar on the home screen and press Enter. The
   [downloading guide](../guides/downloading/index.md) explains what happens next.

On first run monloader writes `/config/monloader.toml` with defaults, plus a
managed `gallery-dl.json` next to it. Most settings are editable from the
Settings page; the full reference, including the environment variables that
override any TOML key, is in [configuration](../configuration.md).

## Volumes

| Mount | Purpose |
|---|---|
| `/config` | Persistent: `monloader.toml`, the managed `gallery-dl.json`, the gallery-dl download archive, and cookies files. |
| `/ptr` | Optional: the local Hydrus PTR tag index, only if you enable the PTR lookup. Expect more than 70 GB. See [Hydrus PTR](../guides/ptr/index.md). |

monloader also uses an internal `/work` directory as scratch space for
downloads; files are deleted from it after each successful push (it doesn't need to be mounted). If you want
it RAM-backed, give it a `tmpfs` mount instead.

## Podman

A Quadlet unit ships at `docker/monloader.container` in the monloader
repository, with the same volumes and hardening as the compose service.
