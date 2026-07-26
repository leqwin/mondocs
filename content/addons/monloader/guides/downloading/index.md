---
title: Downloading
weight: 10
---

## Sending URLs to the queue

![The queue with a re-submitted post, a capped tag search, and a pool](queue.png)

The home screen is a single command bar. Paste a URL and press Enter; the
job is queued and you land on the queue screen to follow it. Anything a
gallery-dl extractor matches works: a single booru post, a pool, a tag
search, an artist page, a manga or comic gallery, or a direct link to an
image file.

Items can also be added to the queue via:

- The [monsender extension](../../../monsender/guides/sending.md) sends the URL
  of the page you are browsing with one click.
- Scripts can `POST /api/v1/queue` with a bearer token; see
  [API and development](../../development.md).

The add bar also accepts a bare md5 hash to import the booru post carrying
that file; see [tagging by hash](#tagging-by-hash) below.

## What happens to a job

A queued URL is a job. The worker first resolves it with gallery-dl to learn
which posts it expands to (one job becomes one or more items). Each item is
then downloaded to scratch space, its metadata is
[mapped onto monbooru's model](../mapping.md), and the file is pushed into the
target monbooru gallery over the API. Files are deleted from scratch space
once monbooru has accepted them; monloader keeps no copy of anything.

## Per-item outcomes

Every item ends with one of seven outcomes, never silently dropped:

| Outcome | Meaning |
|---|---|
| `created` | new image accepted by monbooru |
| `duplicate` | monbooru already had this exact file; any new tags merge in |
| `enriched` | a metadata-only refetch or a hash lookup merged tags into an image monbooru already holds |
| `replaced` | the post's file was pushed over an existing image's, keeping its tags and history - this is monbooru's **[upgrade]** action doing its work through monloader (see [Lookup and sources](../../../../guides/lookup/index.md)) |
| `skipped_archive` | this post was already fetched before; not downloaded again |
| `skipped_unsupported` | monbooru cannot ingest this file type; not pushed |
| `failed` | something went wrong; the row shows the reason |

monbooru ingests jpg, png, webp, gif, mp4, webm, and cbz files; a download
of any other type (audio, svg, a document) is `skipped_unsupported` rather
than pushed and rejected. A `failed` item carries a stable machine-readable
error code; the full table is in
[API and development](../../development.md#error-codes).

Each job row aggregates its items into summary counts (created / duplicate /
enriched / replaced / skipped / failed / canceled), so a single post that was
already saved reads as "duplicate" at a glance.

## Large searches: the cap

A tag search or an artist page can expand to thousands of posts, so a job
takes at most `max_items_per_job` posts (default 200). When the job is capped, a row note showing that more is available offers two
actions:

- **get next N** fetches the next window of the search. N is what the click
  will really take, so it follows the cap down if you lower it afterwards.
- **get all** keeps fetching window after window until the search runs
  short.

A search and its continuations collapse into one queue row with summed
counts. Booru pools and manga galleries are exempt from the cap (they are
one work you asked for as a unit and always come down whole).

## Retry, force, and cancel

- **retry** re-runs a job. For a bulk search that finished cleanly, posts
  already fetched are skipped (`skipped_archive`). A job that did not fetches everything again, because a post it had downloaded may never
  have reached monbooru. Not shown on a job where everything succeeded.
- **force download** appears when a job has archive-skipped items: it
  bypasses the skip and fetches them again (useful to re-import a post
  whose image you deleted in monbooru). On a search that was continued, it
  covers every window the row counts, not just the last batch. (Items
  skipped as unsupported get no such offer; re-downloading would change
  nothing.)
- Re-submitting a **single post** always re-fetches it: monbooru recognizes
  the file and merges any new tags into the existing image, so this is how
  you refresh one post from its source.
- **cancel** stops a job whether or not it has started; items still in
  flight end as canceled, finished ones keep their outcome. 
  **remove** clears a finished row (for a search series, the whole series)
  and asks first, and **clear** next to the add bar removes all finished
  rows at once.

The queue survives a restart: your recent history comes back, jobs that
were still waiting resume, and a job that was mid-download when the app
stopped comes back marked **interrupted**. **clear** empties the finished rows and **cancel pending** empties the not-yet-started ones. 

Finished rows also go on their own after a week, so the queue does not fill
up with downloads you have long stopped caring about. The status column
shows how long each row has been in its state ("5m ago", "3d ago"), with
the exact time on hover, so you can see what is about to go. Change the week
in **Settings -> downloads -> clear history after (days)**, or set it to 0
to keep rows until the queue's max limit of 100 pushes them out.

## Pause and resume

The pause button in the topbar of the queue, PTR and settings pages (and
in the monsender popup) holds all downloads globally: the job in flight
finishes, then nothing new starts until you resume. Use it to queue up a
batch before letting it run.

The pause itself does not survive a restart: the queue and its history
come back (see above), but a restarted monloader starts unpaused, so
anything still pending begins downloading again.

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
- **Lookup enrich**: monbooru's lookup buttons ask monloader to find
  tags for an image it already holds and merge them in, without
  re-downloading the file.

Both show up on the queue page as jobs like any other.
