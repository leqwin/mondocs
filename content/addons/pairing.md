---
title: Pairing
weight: 20
---

The apps talk to each other over their REST APIs, and every API call
needs a token. Pairing is how those tokens get created without you
copying keys between settings pages: one side asks, you approve on the
other side, and the two exchange scoped tokens on their own.

There are two links:

**monloader and monbooru.** In monloader, **Settings -> monbooru ->
connect to monbooru** sends the request; you approve it in monbooru
under **Settings -> Monloader**. monbooru issues monloader a token
(read and write, so it can push downloads), and stores the token
monloader offers in return, which is what powers monbooru's lookup
features and its "connected to monloader" footer light.

**monsender and monloader.** In the extension options, **connect to
monloader** sends the request; you approve it in monloader under
**Settings -> monsender**. The extension polls until the token is
issued, then keeps it locally in the browser. There is no manual token
field: pairing is the only way the extension gets access.

## Rules of thumb

- Each pairing is approved once and then persists. Tokens are scoped
  to what the peer actually needs; removing the pairing revokes them.
- To re-pair, remove the existing pairing on both sides, then connect again.
- In monsender, changing the monloader URL clears the stored token, so
  a moved server means pairing again.
- A rejected token shows up as an authentication error in the asking
  app (monsender shows a red connection dot, monbooru's monloader
  light goes off). Removing and redoing the pairing fixes it.

Per-app detail: [monloader pairing](monloader/getting-started/pairing/index.md),
[monsender setup](monsender/getting-started/setup/index.md), and for
third-party API clients, manually created tokens in
[monbooru development](../development.md) and
[monloader development](monloader/development.md).
