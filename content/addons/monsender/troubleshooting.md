---
title: Troubleshooting
weight: 90
---

## The connection dot

The popup and the options page show a dot for the monloader
connection:

- **green (connected)** - monloader answered and accepted the token.
  On the options page it also shows the monloader and gallery-dl
  versions.
- **checking** - a probe is in flight; give it a second.
- **red (unreachable)** - no answer at the configured URL. Check that
  monloader is running, that the URL in
  [settings](settings/index.md) is the one your browser can reach (open it
  in a tab to be sure), and that you accepted the host permission
  prompt (below).
- **amber (token rejected)** - monloader answered but refused the
  token (a 401). You will see it before the first pairing is done (URL
  saved, no token yet), after the token was revoked in monloader, or
  after a monloader reinstall. Fix: open options and
  **connect to monloader** again, then approve the request in
  monloader under **Settings -> monsender**.

## "host access was not granted"

The extension can only talk to an origin you have approved. If you
dismissed or declined the browser's permission prompt when saving the
URL, every call fails and the options page shows "allow host access
(save first)". Click **save** or **connect to monloader** again and
accept the prompt this time.

## After changing the monloader URL

Saving a new URL clears the stored token: a token belongs to the
instance that issued it. The dot turns to "token rejected" or
monloader asks for auth until you pair again: **connect to
monloader**, approve in monloader, done.