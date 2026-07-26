---
title: Lookup
weight: 95
---

A lookup reverse-searches one of your images against external sources
to backfill its tags and sources: "where does this picture come from,
and what do other people tag it?".

![The batch lookup dialog](lookup-dialog.png)

monbooru itself never goes online. Every lookup runs through a paired
[monloader](../../addons/monloader/_index.md) instance, so set one up
first: the [addons quick start](../../addons/quick-start.md) walks
through starting monloader next to monbooru and pairing the two. The
actions below stay hidden until the link is up. How the lookup chain
itself works (which services are asked, in which order, similarity
floors) is documented on the
[monloader lookup page](../../addons/monloader/guides/lookup/index.md).

## What a lookup searches

Two backends, depending on what monloader has enabled. Each has its own
button on the image page; the batch dialog can run both in one pass:

- **Online boorus and similarity services**: matches the file by its
  md5 hash on booru sites, and by image similarity through IQDB and
  SauceNAO. A booru hit records a new source on the image and merges
  in its tags.
- **Hydrus Public Tag Repository (PTR)**: matches the file by its
  sha256 against monloader's local PTR index. Only available once
  monloader's PTR index has finished syncing - a partial copy would
  answer a few of a file's tags as if they were all of them. Pulls the
  matched post's tags.

Boorus index the original file's hash, so a resized or re-encoded copy
usually misses on hash and only turns up similarity candidates. A miss
reports what was searched along with the file's hashes; a similarity
candidate carries a `~NN%` match score.

## Running lookups from monbooru

- **Detail page, Lookup online boorus.** Sits in the tag editor next
  to Auto-tag (the `L` key does the same). Runs the online backend
  only: the md5 search on the boorus plus the similarity services. A
  found post's tags are merged in and the post is recorded as a new
  source.
- **Detail page, Pull tags.** The PTR backend has its own button, on
  the **Public Tag Repository** panel below the tag editor - the same
  panel used for [contributing to the PTR](../ptr-contributions/index.md).
  The panel compares your tags against the PTR's, and when the synced
  index holds tags this image lacks, **Pull tags** fetches them in.
  Pulling needs no contribution account, only the finished sync.
- **Detail page, source refresh.** Each source row with a URL has a
  **refresh** action that re-pulls that post's tags, commentary and
  notes. A `ptr` source has no URL and refreshes by sha256.
  A refresh never deletes tags: ones the source no longer lists are
  kept under a **Stale tags added by ...** group - see
  [Provenance](../provenance/index.md#which-sources-gave-a-tag).
- **Detail page, upgrade.** When a source serves a different file than
  your local copy, its row offers **[upgrade]**. A similarity match
  differs by definition (that is how it was found); an exact source
  can start differing later, which a refresh detects and marks with a
  **file differs** hint. Upgrading downloads the post's file through
  monloader and replaces your local file in place: the image keeps
  its tags, sources, relations and notes, and gets the new file's
  resolution, thumbnail and embedded metadata. The old file is gone
  once the swap lands, so the action sits behind a confirm. If the
  post's file is already in your gallery as another image, nothing is
  replaced - the two are recorded as potential duplicates and the
  message links the other image so you can settle the pair in the
  relations review.
- **Batch, Find tags.** The gallery's **Actions** chooser and the
  selection batch bar (the `L` key while a selection is active) run a
  lookup across the whole scope: either refresh tags from every source
  declared on each image, or run the hash and similarity lookup per
  image. With the PTR synced the hash mode can be narrowed to **PTR
  only** or **online boorus only**, so a large batch can stay on the
  free local index or spare the online services.
- **Tags page, Find aliases and implications.** Pulls a tag's known
  relations from the PTR into your catalog - aliases pointing at it, the
  tags that imply it, and the tags it implies - for the selected rows or
  the whole current search, from the selection bar's **Find aliases and
  implications** button. With no filter active, "all matching" covers the
  whole catalog. See [Tags](../tags/index.md#the-tags-page).

A booru post that names a parent post links the two as a derivative
relation once both are in the gallery - see
[Relations](../relations/index.md).
