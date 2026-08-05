---
title: Troubleshooting
weight: 90
---

## The connection dot

The popup and the options page show a dot for the monloader
connection:

- **green (connected)** - monloader answered and accepted the token.
- **red (unreachable)** - no answer at the configured URL. Check that
  monloader is running, that the URL in
  [settings](settings/index.md) is the one your browser can reach
  (open it in a tab to be sure), and that you accepted the host
  permission prompt (below).
- **amber (token rejected)** - monloader answered but refused the
  token (a 401): before the first pairing, after the token was
  revoked, or after a monloader reinstall. Fix: **connect to
  monloader** in options, then approve the request in monloader
  under **Settings -> monsender**.

## "host access not granted"

The extension can only talk to an origin you have approved. If you
dismissed or declined the browser's permission prompt when saving the
URL, or revoked the permission later, every call fails - and from the
browser's side a missing permission looks exactly like a dead server.
The fix: open options, click **save** or **connect to monloader**,
and accept the prompt. If monloader is running and the
popup still says it cannot be reached, check this before you go
looking at the server.

## An image is missing from a scan

The chooser only lists what monbooru can store: jpg, png, gif and
webp images, mp4 and webm video. An svg logo, an avif or heic photo,
or an mkv clip is left out, because monloader refuses those before it
starts downloading. Tiny images are dropped too - see
[min image size](settings/index.md).

## After changing the monloader URL

Saving a new URL clears the stored token, so the dot reads "token
rejected" until you
[pair again](getting-started/setup/index.md#if-you-change-the-url-later).
