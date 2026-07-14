---
title: The queue view
weight: 30
---

The bottom of the popup shows monloader's recent jobs, refreshed every
two seconds while the popup is open. Jobs you sent from this browser
carry a small marker. Hover a row to see its outcome spelled out in
the result line; click the monsender name in the header to open
monloader's full queue page in a tab.

## Reading a row

Each row shows the job's status, its site, and terse counts:

- **queued** - waiting for a worker.
- **running** - downloading now; the row shows progress like "3/8".
- **succeeded** - everything in the job worked.
- **partial** - some items worked, some failed; the counts say which.
- **failed** - nothing worked; hover for the reason.
- **canceled** - stopped by you.

The counts use monloader's outcome words. In plain terms:

- **created** ("new") - a new post landed in monbooru.
- **duplicate** ("dup") - monbooru already had this exact file. No
  copy is made, but any new tags from the source merge into the
  existing image, so re-sending a post is also how you refresh it.
- **skipped** ("skip") - monloader itself remembers having downloaded
  this before and skipped re-fetching it. Harmless.
- **failed** ("fail") - this item could not be fetched or stored; the
  reason is one of the [error messages](../troubleshooting.md).
- **canceled** ("cancel") - stopped before it finished.

A large search or pool that hits monloader's per-job limit has more
to fetch. The row does not say "capped" in so many words - the tell is
the extra actions it offers, **[continue]** and **[fetch all]** (and a
single send reports "added, more available").

## Per-job actions

Each row offers the actions that make sense for its state, as
bracketed links:

- **[retry]** - run the job again. Items fetched before come back as
  "skip", so a retry only redoes what failed. Not shown on a job that
  fully succeeded.
- **[force download]** - shown when a job has skipped items: re-fetch
  them even though monloader remembers them. Useful when you deleted
  something from monbooru and want it back.
- **[continue]** - on a capped job, fetch the next batch past the
  limit.
- **[fetch all]** - keep fetching batch after batch until the search
  runs out. A capped search and its follow-ups collapse into one row
  with summed counts.
- **[cancel]** - stop a queued or running job.

**[clear]** in the "recent" header removes all finished jobs from
monloader's queue; running and queued jobs are left alone.

## Pausing downloads

The pause button next to the monsender name holds monloader's whole
queue: click it and new downloads stop starting (indigo means running,
orange means held); click again to resume. This is the same global
pause as on monloader's own pages, so pausing here pauses everywhere.
The button only appears while monloader is reachable.

For everything the queue can do beyond this popup subset, see
[downloading with monloader](../../monloader/guides/downloading/index.md).
