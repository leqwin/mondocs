---
title: Manga and comic archives
weight: 35
---

A CBZ or ZIP archive of images is ingested as a single item, like an
image: one entry in the grid, one set of tags, one rating. Its
thumbnail is the first page, and its detail page adds **Open in
reader** and **See all pages**.

The reader remembers where you stopped: come back and the button
reads **Open in reader (p. 12)** and takes you there.

If the archive carries a `ComicInfo.xml`, its series, author and
other fields show in a read-only metadata panel. **Re-extract
metadata** under **Settings -> Maintenance** re-parses it after the
archive changed on disk.

The [auto-tagger](../auto-tagger/index.md#videos-and-archives) tags
an archive from its pages, merging the per-page results into one set
of tags for the whole item.

## Extracting a page

A single page can be pulled out of the archive as an image of its
own: **Extract** in the reader bar (or the `e` key) saves the current
page as a new file in your upload folder, ingests it, and takes you
to its detail page to tag it.
