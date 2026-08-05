---
title: Maintenance
weight: 110
---

monbooru needs no routine maintenance; the tools below cover the cases
where you moved things around behind its back, restored a backup, or
want to reclaim space.

## Manual tools

**Settings -> Maintenance** has the one-shot tools. Most report how
many rows they touched; Vacuum and Free memory report space reclaimed.

- **Missing images** (Prune): delete the database rows of files no
  longer on disk, along with their thumbnails. (A sync only marks such
  rows missing; this removes them.)
- **Orphaned thumbnails** (Remove): delete thumbnail files whose image is
  gone.
- **Rebuild thumbnails**: regenerate every thumbnail, including manga
  covers and page thumbnails. Useful after an import or a backup
  restore. Also re-probes video dimensions.
- **Compute perceptual hashes**: backfill the perceptual hash for
  every image that lacks one. The relations pair finder needs it; see
  [Relations](relations/index.md).
- **Rebuild pair queue**: wipe the relation candidate queue (skipped
  pairs included) and rescan from scratch.
- **Tag counts** (Recalculate): recompute every tag's usage count. The
  watcher and bulk operations keep counts correct in real time, so you
  only need this if you spot discrepancies. Zero-usage tags persist;
  delete them individually on the Tags page if you want them gone.
- **Category conflicts**: count tags whose name lives in more than one
  category (e.g. `general:nintendo` and `copyright:nintendo`). Legal,
  but usually means two sources disagreed; the count links to the Tags
  page's Conflicts filter where both sides can be merged.
- **Find folded duplicates** (Scan): pair each tag an older pull stored
  folded (like `fate_grand_order`) with the corrected spelling that now
  supersedes it (`fate/grand_order`), for the Tags page's Folded
  duplicates filter. Refresh the affected images first so the corrected
  spelling is present; the scan only pairs spellings you already have.
- **Re-extract metadata**: re-run SD/ComfyUI metadata extraction on
  every image, re-probe video durations, and re-parse comic archives'
  `ComicInfo.xml`.
- **Vacuum database**: compact the database file and release space
  back to the filesystem.
- **Free memory**: shrink the database caches, return heap to the
  system, and unload the auto-tagger from RAM/VRAM.

To find and remove byte-identical duplicate files, use the SHA-256
duplicates tool under **Relations -> Duplicates**; see
[Relations](relations/index.md#cleaning-up-duplicates).

## Nightly schedule

**Settings -> Schedule** turns on a daily run at a chosen time
(default 01:00). Tick any of:

- Sync gallery
- Remove orphaned thumbnails
- Run enabled auto-taggers (off by default)
- Find relation pairs (off by default)

The scheduler runs through every gallery in turn. If a job is already
running at fire time, the run is skipped silently.

## Stats

**Settings -> Stats** is a read-only diagnostic block: process memory
broken down by what holds it, the auto-tagger's current mode (CPU or
GPU), load status and memory, database size per gallery, and free
space on every filesystem your galleries and data live on.

## Troubleshooting

**Degraded mode banner.** The gallery folder is unreadable. Existing
entries stay browsable but sync and the watcher are off. Fix the path
or its permissions and restart.

**Missing thumbnails.** Run Maintenance -> Rebuild thumbnails. Video
and animated GIF previews need ffmpeg, which ships with the Docker
image.

**Watcher hits the inotify limit.** Logged as `no space left on
device` from `inotify_add_watch`. Raise
`fs.inotify.max_user_watches` on the host (not inside the container)
and restart. If you see `too many open files` instead, raise
`fs.inotify.max_user_instances`. Or disable the watcher in Settings
and use Sync manually.

**Permission errors on delete or move.** monbooru takes ownership of
files at ingest so it can delete or move them later. Files ingested by
an old version may predate this; run a Sync, which re-claims files as
it re-hashes them.

**Files added but not visible.** Check that they are under the gallery
path, under the `max_file_size_mb` limit, and that the extension is
one of jpg/jpeg/png/webp/gif/mp4/webm/cbz/zip. Then run Sync.

**Locked out of the login.** The login backoff caps at 30 seconds and
clears after a few minutes idle. Wait it out, or restart the process
to clear all sessions.

**API returns 503 `api_disabled`.** No API token exists yet; create
one in Settings -> Authentication. See
[Development](../development.md). The same status appears when no
gallery is active.
