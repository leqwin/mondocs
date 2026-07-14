---
title: Collections
weight: 70
---

A collection is a named, ordered set of images: a comic told in
loose pages, a photoset, an artist's series. It is a lighter grouping
than a [relation](relations/index.md) - no original, no direction, just
membership and an order. An image can belong to several collections at
once, with its own position in each.

On the detail page, images from the same collection render in their
own "Same collection" strip below the related-images panel, so you can
read through a set in order.

## Filing images

On the detail page, the **Collections** metadata row lists the image's
memberships as chips, each with its position. Use **+ add** to file
the image into a collection (the name autocompletes against existing
ones; a new name creates the collection), **edit** to rename the
membership or change its position, and **x** to remove it.

To file many images at once, use **Set collection** in the gallery's
Actions chooser (whole current search) or the batch bar (selection).
The dialog's Add/Remove radio either files every targeted image under
the label or removes the label from them.

## The Collections page

The Collections page lists every collection with its member count.
From there you can:

- **Rename** a collection across all its members.
- **Reorder** members.
- **Dissolve** a collection: the images stay, the grouping goes.
- Toggle **find relations** per collection. By default the
  near-duplicate pair finder skips pairs that share a collection
  (the collection already relates them); the switch opts a collection
  back in. See [Relations](relations/index.md#finding-candidate-pairs).

## Searching and sorting

`collection:"name"` finds a collection's members, `collection:` images
in no collection, `collection:any` images in at least one. The
**Collection order** sort groups results by collection and reads each
one in its own order; when the search pins a single `collection:`,
results follow exactly that collection's order. Details in
[Searching](searching/index.md#folder-source-collection).
