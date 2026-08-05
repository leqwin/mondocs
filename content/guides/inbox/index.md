---
title: Inbox
weight: 30
---

Every newly added image lands in the **inbox**, whether it came from
the watcher, a sync, a browser upload, the API or monloader. The inbox
is the "not reviewed yet" pile; once you have checked an image's tags
and rating, flip it to **archived**. Nothing forces you to triage, but
the split keeps new arrivals from mixing into your curated library.

![The inbox with a batch cluster](inbox.png)

The inbox is a regular search (`inbox:true`), so every search filter
and sort combines with it.

## Uploading

While you are on an inbox search, a drop zone sits at the top of the
grid. Accepted formats: JPEG, PNG, WebP, GIF, MP4, WebM, and CBZ/ZIP
comic archives. Duplicate filenames are auto-suffixed; a file you
already have (same checksum) is recognized and not stored twice.

## Flipping between inbox and archived

Flip one image from its detail page (keyboard: `i`), or many at once
from the gallery's Actions chooser or the selection batch bar: each
targeted row flips, inbox to archived and archived to inbox.

## Batch clusters

While the gallery is sorted newest-first on an `inbox:true` search,
rows are grouped into batches with a header above each group. Each web
upload (one drop) is its own batch; files that arrived on disk are
grouped by time, with a new group starting after 15 minutes of
inactivity.

A header's **Select** ticks the whole group into the batch bar, so a
batch action can tag or archive the whole download at once.
Its time-range label links to a search pinning exactly that batch,
useful when a batch spills across pages.
