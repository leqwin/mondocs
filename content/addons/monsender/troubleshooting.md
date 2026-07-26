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

## "host access not granted"

The extension can only talk to an origin you have approved. If you
dismissed or declined the browser's permission prompt when saving the
URL, or revoked the permission later, every call fails. The popup says
"host access not granted" and points you at options; the options page
says "allow host access (save first)". Either way the fix is the same:
open options, click **save** or **connect to monloader**, and accept
the prompt this time.

As because a missing permission looks exactly
like a dead server from the browser's side: both are just a failed
request. If monloader is running and the popup still says it cannot be
reached, check the permission before you go looking at the server.

## An image is missing from a scan

The chooser only lists what monbooru can store: jpg, png, gif and webp
images, mp4 and webm video. An svg logo, an avif or heic photo, or an
mkv clip is left out, because monloader refuses those before it starts
downloading. Nothing is wrong; there is just nowhere for that file to
go. Tiny images are dropped too - see
[min image size](settings/index.md).

## After changing the monloader URL

Saving a new URL clears the stored token: a token belongs to the
instance that issued it. The dot turns to "token rejected" or
monloader asks for auth until you pair again: **connect to
monloader**, approve in monloader, done.