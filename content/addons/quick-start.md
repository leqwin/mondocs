---
title: Quick start
weight: 10
---

monbooru on its own needs no quick start beyond
[its install page](../getting-started/install.md). This page
is for the next step: adding monloader (downloads and lookups) and the
monsender extension to a monbooru you already run.

## 1. Start with monbooru

If it is not running yet, follow
[installing monbooru](../getting-started/install.md), then
open `http://localhost:8080` and check that you can access it.

## 2. Start monloader

monloader ships as a commented-out service in monbooru's
`docker/docker-compose.yml`, already on the same network. Uncomment it
and start it:

```bash
docker compose up -d monloader
```

Then open `http://localhost:8081`.

## 3. Pair monloader with monbooru

1. In monloader, go to **Settings -> monbooru**. The default api url
   `http://monbooru:8080` is right for the shared compose network.
2. Click **connect to monbooru**.
3. In monbooru, open **Settings -> Monloader** and approve the request.
4. Back in monloader, pick a **default gallery** and save.

That is the whole handshake; the apps exchange tokens themselves. From
now on monloader pushes downloads into that gallery, and monbooru's
footer shows a "connected to monloader" light.

To try it: paste a post URL from a booru site into monloader's queue page
and watch it arrive in monbooru, tags included.

## 4. Add the browser extension

1. [Install monsender](monsender/getting-started/install.md) in
   Firefox or Chrome.
2. In the extension options, set the monloader URL - the address your
   browser reaches it at, so `http://localhost:8081` on the same
   machine, or your server's LAN address like
   `http://monloader.lan:8081`.
3. Click **connect to monloader**, then approve the request in
   monloader under **Settings -> monsender**.

Now browse to a post on a supported site and press the toolbar button
(or Ctrl+Shift+L). The page goes to monloader, downloads, and lands in
monbooru.

## Where next

- [Searching your collection](../guides/searching/index.md)
- [Which sites monloader supports](monloader/guides/sites/index.md)
- [Sending pages from the browser](monsender/guides/sending.md)
- [How pairing works in general](pairing.md)
