---
title: Downloading
weight: 10
---

## Sending URLs to the queue

![The queue page with a finished search job](queue.png)

The home screen is a single command bar. Paste a URL and press Enter; the
job is queued and you land on the queue screen to follow it. Anything a
gallery-dl extractor matches works: a single booru post, a pool, a tag
search, an artist page, a manga or comic gallery, or a direct link to an
image file.

Two other ways in:

- The [monsender extension](../../../monsender/guides/sending.md) sends the URL
  of the page you are browsing with one click.
- Scripts can `POST /api/v1/queue` with a bearer token; see
  [API and development](../../development.md).

The add bar also accepts a bare md5 hash to import the booru post carrying
that file; see [tagging by hash](#tagging-by-hash) below.

## What happens to a job

A queued URL is a job. The worker first resolves it with gallery-dl to learn
which posts it expands to - one job becomes one or more items. Each item is
then downloaded to scratch space, its metadata is
[mapped onto monbooru's model](../mapping.md), and the file is pushed into the
target monbooru gallery over the API. Files are deleted from scratch space
once monbooru has accepted them; monloader keeps no copy of anything.

## Per-item outcomes

Every item ends with one of six outcomes, never silently dropped:

| Outcome | Meaning |
|---|---|
| `created` | new image accepted by monbooru |
| `duplicate` | monbooru already had this exact file; any new tags merge in |
| `enriched` | a metadata-only refetch or a hash lookup merged tags into an image monbooru already holds |
| `skipped_archive` | this post was already fetched before; not downloaded again |
| `skipped_unsupported` | monbooru cannot ingest this file type; not pushed |
| `failed` | something went wrong; the row shows the reason |

monbooru ingests jpg, png, webp, gif, mp4, webm, and cbz files; a download
of any other type (audio, svg, a document) is `skipped_unsupported` rather
than pushed and rejected. A `failed` item carries a stable machine-readable
error code; the full table is in
[API and development](../../development.md#error-codes).

Each job row aggregates its items into summary counts (created / duplicate /
enriched / skipped / failed / canceled), so a single post that was already
saved reads as "duplicate" at a glance.

## Large searches: the cap

A tag search or an artist page can expand to thousands of posts, so a job
takes at most `max_items_per_job` posts (default 200). The cap is never
silently applied: a capped row notes that more is available and offers two
actions:

- **get next N** fetches the next window of the search (N being the cap).
- **get all** keeps fetching window after window until the search runs
  short.

A search and its continuations collapse into one queue row with summed
counts. Booru pools and manga galleries are exempt from the cap - they are
one work you asked for as a unit and always come down whole.

## Retry, force, and cancel

- **retry** re-runs a job. For a bulk search, posts already fetched are
  skipped (`skipped_archive`). Not shown on a job where everything
  succeeded.
- **force download** appears when a job has skipped items: it bypasses the
  skip and fetches them again - useful to re-import a post whose image you
  deleted in monbooru.
- Re-submitting a **single post** always re-fetches it: monbooru recognizes
  the file and merges any new tags into the existing image, so this is how
  you refresh one post from its source.
- **cancel** stops a running job; items still in flight end as canceled,
  finished ones keep their outcome. **remove** clears a finished row (for a
  search series, the whole series), and **clear** next to the add bar
  removes all finished rows at once (it asks first).

Finished rows also go on their own after a week, so the queue does not fill
up with downloads you have long stopped caring about. The status column
shows how long each row has been in its state ("5m ago", "3d ago"), with
the exact time on hover, so you can see what is about to go. Change the week
in **Settings -> downloads -> clear history after (days)**, or set it to 0
to keep rows until the queue's own limit of 100 pushes them out.

## Pause and resume

The pause button in the topbar of the queue, PTR and settings pages (and
in the monsender popup) holds all downloads globally: the job in flight
finishes, then nothing new starts until you resume. Use it to queue up a
batch before letting it run.

The queue lives in memory: a restart clears pending jobs, the recent
history, and the pause. That is fine in practice - re-submitting a URL is
cheap, since already-fetched posts are skipped and already-pushed files land
as duplicates.

## Pools and manga

Multi-page works are handled by kind:

- A **booru pool** (an ordered set of posts forming one work) imports as an
  ordered collection: each page is pushed as its own image under a shared
  collection label (the pool name) and page number, keeping each page's own
  tags.
- A **manga or comic gallery** is bundled, in order, into a single `.cbz`
  file (a comic book archive) and pushed as one file, which monbooru opens
  in its reader. The bundle's tags are the union across the pages and its
  rating the strictest seen. If any page fails to download, the job fails
  rather than pushing a truncated book.
- A **manga title** page that lists chapters imports each chapter as its own
  `.cbz`.

Some URLs list other pages rather than files - a forum thread whose images
are hosted elsewhere, an archive board. monloader follows these handoffs and
imports the files they lead to as loose items, bounded by the per-job cap.

## Tagging by hash

Two features find a post from a file hash instead of a URL; both walk the
same [lookup chain](../lookup/index.md):

- **Hash import**: paste a file's md5 (bare or as `md5:<hash>`) into the add
  bar and the matching booru post is imported like any single post.
- **Lookup enrich**: monbooru's "fetch tags" button asks monloader to find
  tags for an image it already holds and merge them in, without
  re-downloading the file.

Both show up on the queue page as jobs like any other.
