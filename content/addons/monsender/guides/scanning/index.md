---
title: Scanning a page
weight: 20
---

When a page holds many images and no supported extractor - a forum
thread, a blog post, an image dump - scan it and pick what to keep.

![The side panel after scanning a page](panel.png)

Open the popup and click **scan page**. The chooser opens docked
beside the page (Chrome's side panel, Firefox's sidebar), so it stays
open while you scroll the page to cross-check.

Some pages cannot be read at all - browser-internal pages, the add-on
store, the built-in PDF viewer. The chooser says "this page cannot be
scanned" for those, which is a different answer from "no images
found" on a page it read and came up empty on.

Almost everything a scan finds is a direct file URL, so scanned
images arrive in monbooru untagged (see
[tagged or untagged](../sending.md#tagged-or-untagged-what-arrives)).

## What the chooser lists

Two filters run before anything is shown:

- Images smaller than the **min image size** setting (64 pixels by
  default) are dropped, which removes icons, buttons and tracking
  pixels. Set it to 0 in [settings](../../settings/index.md) to see
  everything.
- File types monbooru cannot store are left out: the chooser lists
  jpg, png, gif and webp images and mp4 and webm video, nothing else.
  A URL with no file extension is still listed, since most CDN images
  carry none and only monloader can tell.

A scan lists at most the configured **scan cap** (100 by default, up
to 1000). When a page holds more, the header reads "scan: 100 of 350
images" so a truncated scan is never mistaken for the whole page.

If some picks fail to queue, the message under the send button says
why and the selection is kept, so you can send again once the cause
is fixed - re-sending the ones that made it is harmless, they come
back as duplicates.

## Picking a resolution

When the page offers an image in several sizes, the card shows one
token per resolution ("1500w", "800w", "src"). The largest is
selected by default. A token reading "src" is one the page gave no
width for; pick it and it relabels itself with the real width once
that version loads.

## Previews

Thumbnails load straight from wherever the images live, by your
browser, with three guards: no referrer is sent, they load lazily as
you scroll, and the grid asks for the smallest version each image
offers - while the card still sends the big version you picked.

If you would rather the chooser contact no outside host at all, turn
off the **previews** checkbox in [settings](../../settings/index.md).
Cards then show the file name instead of a thumbnail, and picking
works the same.

A blank tile marked "preview blocked" means the host refused to serve
the image outside its own site (hotlink protection). You can select
and send a blocked card anyway; monloader may or may not be able to
fetch it, and the queue outcome will tell you.
