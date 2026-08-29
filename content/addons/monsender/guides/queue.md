---
title: The queue view
weight: 30
---

The bottom of the popup shows monloader's recent jobs, refreshed
every two seconds while the popup is open. Jobs you sent from this
browser carry a small marker; click the monsender name in the header
to open monloader's full queue page in a tab.

## Reading the counts

The counts use monloader's outcome words. The queue is monloader's,
not the extension's, so it also lists the jobs monbooru sends there -
reverse lookups, source refetches, file replacements - and those
finish with words a download never produces. In plain terms:

- **created** ("new") - a new post landed in monbooru.
- **duplicate** ("dup") - monbooru already had this exact file. No
  copy is made, but any new tags from the source merge into the
  existing image, so re-sending a post is also how you refresh it.
- **enriched** ("enrich") - a refetch merged fresh tags, commentary or
  provenance into an image monbooru already held.
- **replaced** ("replace") - a better file from the source took the
  place of the one monbooru had.
- **matched** ("match") - a reverse lookup found the image on a site
  but did not change it.
- **skipped** ("skip") - monloader itself remembers having downloaded
  this before, or the item is a media type monbooru will not take.
  Not an error.
- **archived** ("archived") - the archive half of "skip": the posts
  monloader passed over because it already had them.
- **failed** ("fail") - this item could not be fetched or stored; the
  reason is one of the [error messages](../troubleshooting.md).
- **canceled** ("cancel") - the job was stopped before this item ran.

## Per-job actions

- **[retry]** - run the job again. Items fetched before come back as
  "skip", so a retry only redoes what failed.
- **[force download]** - shown when a job skipped posts monloader had
  already downloaded: re-fetch them even though it remembers them.
  Useful when you deleted something from monbooru and want it back.
  It is not offered for items skipped as an unsupported media type,
  since forcing would fetch them again and skip them again.
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
