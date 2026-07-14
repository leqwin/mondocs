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
  just downloaded, so it lands with no tags, rating, or source. The
  popup labels this "direct image - no tags".

When you have the choice, send the post page. Which sites count as
supported is monloader's call; see
[supported sites](../../monloader/guides/sites/index.md).

## The toolbar button

Click the monsender icon. The popup shows the current page's URL with
the label above, and a **send page** button:

- On a recognized site or a direct image, the label above says so and
  **send page** is enabled. Click it and the result shows inline
  within a few seconds: "added -> monbooru #1234", "already in your
  library", or a failure reason. If monloader takes longer than the
  configured wait, the popup shows "queued" and the
  [queue view](queue.md) tracks it from there.
- On other normal websites there is no label, but **send page** stays
  enabled: the hint list covers the common cases, and monloader has
  the final say on whether it can extract anything. A send it cannot
  handle just comes back as "not a supported site".
- Only pages that are not web addresses at all (browser-internal
  pages, local files) grey the button out.

## The keyboard shortcut

Ctrl+Shift+L sends the current page straight away, no popup. The
result shows on the toolbar icon instead: a badge counts the sends
queued since you last opened the popup (a whole search counts as one),
colored by the last outcome (green added, grey duplicate or skipped,
indigo still queued, red failed), and shows a red "!" when a send
queued nothing. Hovering the icon shows the last result as a tooltip;
opening the popup clears the badge. The same gate applies as for the
button.

## Right-click an image or video

Right-click any image or video and pick **Send to monloader**. The
extension sends the best target for what you clicked:

1. the post the media links to, if that link is a supported site (in a
   thumbnail listing, this gets you the tagged post, not the thumb);
2. otherwise the page you are on, if it is a supported site;
3. otherwise the file itself, untagged.

So a right-click on a booru thumbnail sends the tagged post behind it,
and a right-click on a random forum image sends the raw file. When the
file itself is sent, the extension picks the largest version the page
offers, not the downscaled thumbnail being displayed. This menu entry
always works; it is never greyed out.

Since the send happens without the popup, the outcome shows on the
toolbar badge, as with the shortcut.

## Re-sending is safe

Sending something monbooru already has never creates a copy. A
re-sent search skips the posts monloader already fetched ("already
fetched (archive)"); a re-sent single post is re-fetched on purpose,
and any new tags from the source merge into the image monbooru
already holds - that is how you refresh one post. See the
[queue view](queue.md) for what each outcome means.
