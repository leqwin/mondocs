---
title: Sending
weight: 10
---

There are three ways to send something to monloader: the toolbar
button, the keyboard shortcut, and the right-click menu.

## Tagged or untagged: what arrives

monloader treats the two kinds of URL differently, and the extension
labels them so you know before you send:

- A post page on a supported booru site (also a pool, tag search, or
  artist page) is fetched by a site extractor, so the image lands in
  monbooru with its tags, rating, and source. The popup labels this
  "booru - tags will be included".
- A direct image file (a CDN URL like `cdn.example/.../abcd.jpg`) is
  just downloaded, so it lands with no tags or rating. When it is
  sent from the right-click menu or the page scanner, the page you
  were on is recorded as its source in monbooru, so you can find your
  way back to where it came from.

When you have the choice, send the post page. Which sites count as
supported is decided by monloader; see
[supported sites](../../monloader/guides/sites/index.md).

## The toolbar button

The popup shows the current page's URL with its label and a **send
page** button. On an unlabeled site the button still works: the hint
list covers the common cases, and monloader makes the real check - a
send it cannot handle comes back as "not a supported site". Only
pages that are not web addresses at all (browser-internal pages,
local files) grey the button out.

The result shows inline within a few seconds. If monloader takes
longer than the configured wait, the popup shows "queued" and the
[queue view](queue.md) tracks it from there.

## The keyboard shortcut

Ctrl+Shift+L sends the current page straight away, no popup. The
result shows on the toolbar icon instead: a badge counts the sends
queued since you last opened the popup, colored by the last outcome
(green added, grey duplicate or skipped, indigo still queued, red
failed). Hovering the icon shows the last result; opening the popup
clears the badge.

## Right-click an image or video

Right-click any image or video and pick **Send to monloader**. The
extension sends the best target for what you clicked:

1. the post the media links to, if that link is a supported site (in
   a thumbnail listing, this gets you the tagged post, not the
   thumb);
2. otherwise the page you are on, if it is a supported site;
3. otherwise the file itself, untagged - the largest version the page
   offers, not the downscaled thumbnail being displayed.

When the page is what got sent but you had pointed at an image - say
a post that holds a finished work plus process shots - a note appears
next to the image for a few seconds: "sent the post page [only this
image]". Click **only this image** to call off the post download and
send just that file instead. To pick several images from one page,
use the [page scanner](scanning/index.md).

Since the send happens without the popup, the outcome shows on the
toolbar badge, as with the shortcut.
