---
title: Hydrus PTR
weight: 50
---

monloader can answer "what are this file's tags?" from the file's sha256
alone, using a local copy of the
[Hydrus Public Tag Repository](https://hydrusnetwork.github.io/hydrus/PTR.html)
(the PTR) - a community-maintained database of billions of tag-to-file
mappings. It is off by default and downloads nothing until you enable it.

This is the offline companion to the online [lookup chain](../lookup/index.md): the
booru lookup is instant and needs no local data, but only finds files still
hosted on a booru; the PTR also knows files that were deleted or never
posted there, at the cost of a large local index.

## What it costs

The PTR has no per-hash query API - by design, so its server cannot learn
which files you have. Using it means streaming the repository's whole tag
history once and keeping a local index:

- **Initial download**: thousands of small update files, fetched over
  hours.
- **Local index**: a database on its own volume - expect more than 70 GB.
  monloader refuses to start the initial sync when the volume has less than
  `min_free_gb` (default 80) free.
- **Steady state**: one small update roughly every day once caught up.

The index is a rebuildable cache of public data: it can be deleted and
re-synced at any time.

## Enabling it

![The PTR page before enabling](ptr-disabled.png)

1. Mount a dedicated volume at `/ptr` (there is a commented block in the
   shipped `docker-compose.yml` and `monloader.container`). The PTR page
   warns while the data path does not exist: without a volume mounted there,
   the index lands inside the container and is lost when the container is
   recreated.
2. Open **PTR** in the top bar and read the summary: the repository address,
   the data path, and your free space against what the initial sync needs.
3. Click **enable ptr sync** and leave it to catch up (hours). The page
   shows live progress: counts, disk use, and download rate.

You can **pause** and **resume** the sync at any time; it picks up where it
stopped. The confirmed **delete ptr data** button (in the settings ptr
section) turns the lookup off and reclaims the disk. Once caught up, the
page also shows how far in time the synced data reaches ("data through
...").

![The PTR page once the index has caught up](ptr-synced.png)

## Using it

The index answers as soon as it has data, even mid-sync (on whatever it has
so far, which the results may reflect).

- **Tag lookup**: the PTR becomes a backend of the
  [reverse lookup](../lookup/index.md). monbooru shows its PTR lookup option only
  while monloader reports the PTR enabled; each lookup appears as a job on
  the queue page. A PTR match carries tags but no source URL - the PTR maps
  hashes to tags, not to pages.
- **Aliases and implications**: the synced alias and implication graph is
  queryable (up to 500 tags per call), so monbooru can sweep its own tag
  list and propose aliases and implications drawn from the PTR. 

The tags come back in monbooru form: hydrus namespaces are mapped onto
monbooru categories and names are normalized the same way as
[downloaded tags](../mapping.md).

## Configuration

The `[ptr]` block in `monloader.toml`; every key also has a
`MONLOADER_PTR_*` environment override:

```toml
[ptr]
enabled     = false
data_path   = "/ptr"                          # dedicated index volume
address     = "https://ptr.hydrus.network:45871"
access_key  = ""                              # empty = the PTR's public read-only key
fetch_sleep = 1.0                             # seconds between update downloads
min_free_gb = 80                              # refuse the initial sync below this free space
```

These keys are also editable from the settings page's **ptr** section; the
sync engine reads them at boot, so changes apply on restart. The sync
lifecycle itself (enable, pause, resume) lives on the PTR page.
