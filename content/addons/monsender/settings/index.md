---
title: Settings
weight: 80
---

Open the popup and click **options**, or right-click the toolbar icon
and open the extension's options. Everything is stored locally in your
browser.

![The options page](options.png)

## monloader

- **URL** - the base URL your browser reaches monloader at, for
  example `http://localhost:8081` or `http://monloader.lan:8081`.
  Saving asks the browser to allow access to that one origin, then
  tests the connection. Changing the URL clears the stored token, so
  you pair again with the new instance
  ([setup](../getting-started/setup/index.md) walks through it).

Three buttons:

- **connect to monloader** - starts the pairing that gets the access
  token: request, approve in monloader under **Settings -> monsender**,
  done.
- **test connection** - checks reachability and, when a token is
  stored, that monloader accepts it.
- **save** - stores the URL and the sending options below.

The connection indicator below the buttons shows the result:

- green dot with "monloader v... / gallery-dl v..." - reachable, token
  accepted.
- "token rejected" - reachable, but the token was refused; pair again.
- "unreachable" - no answer at that URL.
- "allow host access (save first)" - the origin permission was not
  granted yet; click save and accept the prompt.

## Sending

- **wait (seconds)** - how long a single send waits for its result
  before falling back to the queue. While a send resolves within this
  window, the popup shows the real outcome ("added", "already in your
  library", ...); past it, the popup shows "queued" and the
  [queue view](../guides/queue.md) takes over. Default 20, maximum 60,
  0 means do not wait.
- **scan cap** - the most images a [page scan](../guides/scanning/index.md)
  lists and sends. Default 100, maximum 1000. A truncated scan says so
  ("scan: 100 of 350 images").
- **min image size** (up to 4000) - a scan skips images smaller than this many
  pixels in either dimension, which drops icons and tracking pixels.
  Default 64; 0 turns the filter off.
- **previews** - show thumbnails in the scan chooser. On by default.
  Off means the chooser loads no remote images at all and shows file
  names instead; see
  [previews and privacy](../guides/scanning/index.md#previews).
