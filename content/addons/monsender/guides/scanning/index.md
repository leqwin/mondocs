---
title: Scanning a page
weight: 20
---

When a page holds many images and no supported extractor - a forum
thread, a blog post, an image dump - scan it and pick what to keep.

![The side panel after scanning a page](panel.png)

Open the popup and click **scan page**. The extension reads the images
out of the current page (only then; nothing watches pages in the
background) and opens the chooser beside the page: Chrome's side panel
on Chrome, the sidebar on Firefox. Because the chooser is docked, it
stays open while you scroll the page to cross-check.

Almost everything a scan finds is a direct file URL, so scanned images
arrive in monbooru untagged (see
[tagged or untagged](../sending.md#tagged-or-untagged-what-arrives)).

## The chooser

The panel shows the scanned page's URL, a count, and a thumbnail grid
with a checkbox on each image:

- **[all]** and **[none]** select or clear everything at once.
- **send selected (N)** at the bottom sends your picks. They are
  queued one at a time; the message under the button tracks progress
  and the [queue view](../queue.md) shows the jobs. If some fail to
  queue, the selection is kept so you can send again (re-sending the
  ones that made it is harmless - they come back as duplicates).
- Tiny images are already filtered out: anything smaller than the
  **min image size** setting (64 pixels by default) is dropped, which
  removes icons, buttons, and tracking pixels. Set it to 0 in
  [settings](../../settings/index.md) to see everything.

## Picking a resolution

When the page offers an image in several sizes, the card shows one
token per resolution ("1500w", "800w", "src"). The largest is selected
by default; click a smaller one to send that variant instead. The
token updates to the real width once the preview loads.

## The scan cap and "showing N of M"

A scan lists at most the configured **scan cap** (100 by default, up
to 1000). When a page holds more, the header reads "scan: 100 of 350
images" so a truncated scan is never mistaken for the whole page.
Raise the cap in [settings](../../settings/index.md) if you routinely scan
bigger pages.

## Previews

Thumbnails are loaded straight from wherever the images live, by your
browser, exactly as if the page displayed them - with two guards: no
referrer is sent (cookie behavior follows your browser's third-party
cookie policy), and they load lazily as you scroll
the grid.

If you would rather the chooser contact no outside host at all, turn
off the **previews** checkbox in [settings](../../settings/index.md). Cards
then show the file name instead of a thumbnail, and picking works the
same.

With previews on, a blank tile marked "preview blocked" means the host
refused to serve the image outside its own site (hotlink protection).
You can still select and send it; monloader may or may not be able to
fetch it, and the queue outcome will tell you.
