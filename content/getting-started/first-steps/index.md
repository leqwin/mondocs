---
title: First steps
weight: 20
---

## Add your first images

Two ways in:

- **Point it at a folder.** The default gallery reads `/gallery`
  (whatever host folder you mounted there). Copy files in, and the
  watcher indexes them within seconds. Files that were already in the
  folder before monbooru started are picked up by a sync: click the
  sync icon at the top right (or the [Sync gallery] button the empty
  gallery page offers) to walk the folder in one pass. Subfolders are
  fine; monbooru keeps your folder structure and shows it as a tree in
  the sidebar.
- **Upload from the browser.** Open **Inbox** in the top menu. A drop
  zone sits at the top of the grid: drag files in or pick them with
  **Choose files**. Accepted formats are JPEG, PNG, WebP, GIF, MP4,
  WebM, and CBZ/ZIP comic archives.

Either way, new images land in the [inbox](../../guides/inbox/index.md), a
holding area for things you have not reviewed yet. The same file added
twice (even under two different paths) is recognized by its checksum
and stored as one image.

## The UI at a glance

- **Gallery grid.** The home page. Thumbnails of whatever the current
  search matches; with an empty search you see everything. Hovering a video
  or animated GIF plays a short preview. You can check thumbnails and a
  batch bar appears with actions that apply to the selection.
- **Search bar.** Top of the page. Type tags and filters, for example
  `red_hair -sketch rating:general`. The full syntax is in
  [Searching](../../guides/searching/index.md).
- **Sidebar.** Left of the grid: the tags present on the current page
  of results, top sources, your folder tree, and saved searches.
  Everything in it is clickable and narrows the search.
- **Detail page.** When you click a thumbnail, you see the image with its tags, metadata (size, folder, sources, collections),
  and panels for AI generation data, similar entries and related
  images. Arrow keys walk to the previous and next result relative to the current search.
- **Footer.** Shows the active gallery, library counts, and the SFW
  ceiling: click a rating level (`sfw`, `sensitive`, `questionable`,
  `explicit`) to hide anything ranked above it (useful when someone is
  looking over your shoulder). See
  [Tags](../../guides/tags/index.md) for how ratings work.

## Manga and comic archives

A CBZ or ZIP archive of images is ingested as a single item, like an
image; its thumbnail is the first page. The detail page for an archive
adds **Open in reader** (a built-in page-by-page reader) and **See all
pages** (a thumbnail grid of every page; click one to jump there in
the reader). The reader remembers where you stopped: come back and the
button reads **Open in reader (p. 12)** and takes you there.
Bookmarking the reader's own URL in your browser works too: reopened
without a page number, it lands on where you stopped. If the archive carries a
`ComicInfo.xml`, its series, author and other fields show in a
read-only metadata panel.

A single page can be pulled out of the archive as an image of its own:
**Extract** at the right of the reader bar (or the `e` key) saves the
page you are looking at as a new file in your upload folder, ingests
it like any other image, and takes you to its detail page to tag it.
The new image is linked back to the archive as a derivative, so each
one points at the other under Relations. Extracting the same page
twice takes you back to the image you already made rather than
creating a second copy.

## More galleries

Everything so far happens in the default gallery. A gallery is an
independent library: its own folder, database, tags and saved
searches. If you want a second one (say, wallpapers separate from art),
mount another folder into the container and add it under
**Settings -> Galleries**. Details in
[Galleries](../../guides/galleries/index.md).

## Moving files

Files can be reorganized without leaving the app: **Move image** on
the detail page (shortcut `m`) moves the file to another folder inside
the gallery, creating subfolders as needed, and the Actions chooser
and batch bar carry the same **Move** for a whole search or selection.
The folder tree in the sidebar follows. **Rename image** next to it
renames the file in place (the extension stays put), and the batch
**Rename** gives a whole search or selection numbered names off one
base: `trip01.png`, `trip02.png`, and so on.

## Cheatsheets in the app

- Type `system:` in the search bar to open a dropdown listing every
  search filter, with drill-down hints for each one.
- Press `?` on any page for the keyboard shortcuts overlay - the
  `shortcuts` link in the footer opens the same thing. The UI is
  fully keyboard-drivable, from grid navigation to batch actions.
- The `help` link in the footer opens this documentation.

![The keyboard shortcuts overlay](shortcuts.png)
