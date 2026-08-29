---
title: Moving and renaming files
weight: 75
---

Files can be reorganized without leaving the app. Changes happen to
the real files on disk, so the new layout is what you see outside
monbooru too.

**Move image** on the detail page (shortcut `m`) moves the file to
another folder inside the gallery, creating subfolders as needed. The
Actions chooser and batch bar carry the same **Move** for a whole
search or selection.

**Rename image** renames the file in place (the extension stays put),
and the batch **Rename** gives a whole search or selection numbered
names off one base: `trip01.png`, `trip02.png`, and so on.

## Naming with tokens

Instead of a plain name, any of those fields takes a template:  

| Token | What it is |
|---|---|
| `{name}` | the current name, without the extension |
| `{ext}` | the extension, lower-cased, so `{name}.{ext}` turns `.JPG` into `.jpg` |
| `{id}` | the image's number in this gallery |
| `{hash}`, `{hash:8}` | the sha256, whole or its first few characters |
| `{md5}` | the md5, which is what boorus key their posts on |
| `{date}`, `{year}`, `{month}`, `{day}`, `{time}` | when the file was added |
| `{gallery}` | the gallery's name |
| `{type}` | `jpeg`, `png`, `webm` and so on |
| `{w}`, `{h}`, `{size}` | pixel width, height, and size in bytes |
| `{n}` | the file's position in a batch, zero-padded |

A move field takes `/`, so `archive/{year}/{type}` files each image
under its own year and kind. A rename field does not: a rename keeps
a file in its folder.

Only what is true the moment a file is added can be used, so tags,
collections and ratings are not available.

A token can also be empty for one particular file, like `{w}` on a
video nothing could measure. It renders as nothing and the separators
around it close up. If that
leaves no name at all, the rename or move is refused rather than
applied, so a selection can never end up named after its ids or
emptied into the gallery root.

## Naming files as they arrive

**Settings -> General** has one row, **Where received files go**, that
decides where uploads and anything pushed in over the API land and what
they are called. Both halves take the same tokens, so
`inbox/{year}-{month}` and `{name}-{hash:8}` between them file and name
every incoming file; the line under the row shows the whole path a file
arriving now would end up at. Leave the folder blank for the gallery
root and the name blank to keep whatever the sender called it. An
arriving file has to be called something, so here a template that
renders nothing falls back to the image's id rather than being
refused. A file pushed by
[monloader](../addons/monloader/_index.md) can also use
`{source}` and `{post_id}`, which no other file has:
`{source}-{post_id}` names a pull `danbooru-4821993.jpg`.

Files you drop into the gallery folder yourself are left alone unless
you turn on **Apply to files found on disk too**, which sends whatever
the watcher and a sync pick up to that same place.

It only touches files as they are first
seen, so nothing already in your library is moved behind you. (use manual move/rename instead). And the
very first sync of a library adopts it exactly as it is: a tree you arranged before monbooru ever saw it survives being picked up, and filing starts with the next file that arrives.

To move files between galleries rather than within one, see
[Transfer](galleries/index.md#transfer). If you moved or deleted
files behind monbooru's back, a sync reconciles the difference; see
[Maintenance](maintenance.md).
