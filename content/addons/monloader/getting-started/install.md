---
title: Install
weight: 10
---

monloader needs a monbooru instance to push into; nothing else is required
to start. To bring up the whole stack from scratch, see the
[quick start](../../quick-start.md).

## Quick start (Docker)

monloader ships as a service in monbooru's
`docker/docker-compose.yml`, so starting it there puts the two containers on
one network with no extra wiring.

1. Start it from monbooru's compose file:

   ```bash
   docker compose up -d monloader
   ```

2. Open `http://localhost:8456`. The shipped compose publishes the port on
   `127.0.0.1` only; to reach monloader from another machine on your
   network, adjust the `ports:` line.
3. Pair it with monbooru: see [pairing](pairing/index.md). Approving the
   request issues the API tokens automatically.
4. In monloader's settings, pick a **default gallery** and save.
5. Paste a URL into the command bar on the home screen and press Enter. The
   [downloading guide](../guides/downloading/index.md) explains what happens next.

On first run monloader writes `monloader.toml` with defaults, plus a managed
`gallery-dl.json`. Most settings are editable from the
Settings page; the full reference, including the environment variables that
override any TOML key, is in [configuration](../configuration.md).

## Quick start (desktop)

Download a **desktop** build for your system from the
[releases page](https://github.com/monbooru/monloader/releases), unpack it,
and run it. 

### Where your files go

| | Linux | Windows |
|---|---|---|
| Settings and site profiles | `~/.config/monloader` | `%AppData%\monloader` |
| Queue, cookies, gallery-dl's config, archive and managed install | `~/.local/share/monloader` | `%LocalAppData%\monloader` |
| Log file | `~/.local/share/monloader/logs` | `%LocalAppData%\monloader\logs` |
| PTR index | `~/.local/share/monloader/ptr` | `%LocalAppData%\monloader\ptr` |

A Flatpak install keeps all of those under
`~/.var/app/io.github.monbooru.Monloader/`.

If you put a `monloader.toml` next to the program before starting it,
monloader uses that one and keeps its data in a `data` folder beside it
too. That makes the whole install portable.

## Volumes

| Mount | Purpose |
|---|---|
| `/config` | Persistent: `monloader.toml`, the managed `gallery-dl.json`, the gallery-dl download archive, cookies files, and your edited site profiles under `profiles/`. |
| `/ptr` | Optional: the local Hydrus PTR tag index, only if you enable the PTR lookup. Expect tens of GB. See [Hydrus PTR](../guides/ptr/index.md). |

monloader also uses an internal `/work` directory as scratch space for
downloads; files are deleted from it after each successful push (it doesn't need to be mounted). If you want
it RAM-backed, give it a `tmpfs` mount instead.
