---
title: Pairing
weight: 20
---

Pairing connects the apps without copying keys around: one side asks, you
approve on the other side, and a scoped API token is issued automatically.
The model is described once in
[pairing across the apps](../../../pairing.md); this page is the
monloader side of it.

monloader sits in the middle, so it pairs twice: with monbooru (approved on
the monbooru side) and with the monsender browser extension (approved on the
monloader side).

## Pair with monbooru

1. In monloader, go to **Settings -> monbooru** and confirm the **api url**.
   The default `http://monbooru:8080` works when both containers share
   monbooru's compose network.
2. Click **connect to monbooru**.
3. In monbooru, approve the pending request in its monloader settings.

   ![The pairing request waiting for approval in monbooru](approve-request.png)

4. Back in monloader, pick a **default gallery** (the dropdown appears once
   paired) and save.

   ![monloader's Settings -> monbooru section once paired](settings-monbooru.png)

Approving provisions tokens in both directions: monbooru issues monloader a
read and write token (stored as `[monbooru].api_token` in monloader's
config) so it can push images, and monloader issues monbooru a
`monbooru (paired)` token on its own API so monbooru can trigger lookups and
source refetches. The monbooru-side token cannot delete anything and never
touches gallery files.

## Pair with monsender

1. In the monsender extension's options, set monloader's URL and click
   **connect to monloader**. The extension-side steps are in
   [monsender setup](../../../monsender/getting-started/setup/index.md).
2. In monloader, approve the request under **Settings -> monsender**.
   Approving mints a scoped `monsender (paired)` token that the extension
   stores.

## Paired tokens

Paired tokens appear in **Settings -> Authentication** next to any tokens
you created yourself, but their scopes are read-only and they cannot be
revoked directly: remove the pairing instead.

## Re-pairing

A peer that is already paired is refused until its pairing is removed.
Removing a pairing (on either side) drops the local token and asks the peer
to drop its own; if the peer was unreachable at that moment, a notice
reminds you to remove it there too. monloader keeps the configured monbooru
api url, so a re-pair reuses it.

## Manual setup

If you would rather manage the monbooru token by hand, set
`[monbooru].api_token` in `monloader.toml` or the
`MONLOADER_MONBOORU_API_TOKEN` environment variable; there is no UI field
for it. The value must be a monbooru API token with read and write scope.
