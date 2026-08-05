---
title: The queue view
weight: 30
---

The bottom of the popup shows monloader's recent jobs, refreshed
every two seconds while the popup is open. Jobs you sent from this
browser carry a small marker; click the monsender name in the header
to open monloader's full queue page in a tab.

## Reading the counts

The counts use monloader's outcome words. In plain terms:

- **created** ("new") - a new post landed in monbooru.
- **duplicate** ("dup") - monbooru already had this exact file. No
  copy is made, but any new tags from the source merge into the
  existing image, so re-sending a post is also how you refresh it.
- **skipped** ("skip") - monloader itself remembers having downloaded
  this before and skipped re-fetching it. Not an error.
- **failed** ("fail") - this item could not be fetched or stored; the
  reason is one of the [error messages](../troubleshooting.md).

## Per-job actions

- **[retry]** - run the job again. Items fetched before come back as
  "skip", so a retry only redoes what failed.
- **[force download]** - shown when a job has skipped items: re-fetch
  them even though monloader remembers them. Useful when you deleted
  something from monbooru and want it back.
- **[continue]** - on a capped job, fetch the next batch past the
  limit. **[fetch all]** keeps fetching until the search runs out; a
  capped search and its follow-ups collapse into one row with summed
  counts.
- **[clear]** in the header removes all finished jobs from
  monloader's queue; running and queued jobs are left alone.

## Pausing downloads

The pause button holds monloader's whole queue: new downloads stop
starting until you click it again. This is the same global pause as
on monloader's own pages, so pausing here pauses everywhere.

For everything the queue can do beyond this popup subset, see
[downloading with monloader](../../monloader/guides/downloading/index.md).
