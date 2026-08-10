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

## Turning an archive into a collection

Sometimes an archive should be a set of separate images: you
want to tag each page on its own, drop the credit pages, or keep only
a few variants. **Generate collection** on the archive's detail page
does allows you to unpack it. Every page is saved as its own
image, ingested, and filed into a collection you name, in page order.

The pages land together in their own folder inside your upload
folder, named after the archive. Each page is linked back to the archive as a derivative, so you can always find where it came from.

Nothing is deleted: the archive stays exactly as it was, and none
of its tags are copied onto the pages. If a page is identical (same hash) to an image you already have, that existing image joins the collection instead of being duplicated.

The reverse action, packing a collection into an archive, is in
[Collections](../collections/index.md#turning-a-collection-into-an-archive).
