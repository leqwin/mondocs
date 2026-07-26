---
title: Migrating
weight: 90
---

If you're already an user of another application similar to monbooru, monbooru's import dialog
(**Settings -> Galleries -> Import**) accepts an export archive from
a supported application and translates it on the fly. The compatibility layer
carries images and tags only - it is meant to move your library and
its tagging over, not every application-specific detail.

Once you have produced the zip, drop it into the import dialog like
any other archive and pick **Merge** or **Replace** on a gallery. See
[Galleries](galleries/index.md#import) for what the two modes do.

## Hydrus Network

1. In Hydrus, select the files you want to export. Right-click ->
   **share** -> **export** -> **files**.
2. In the export dialog, add a sidecar **.txt** with the **all known
   tags / display tags** preset. Each exported image then gets an
   adjacent `<filename>.txt` listing one tag per line. Tags namespaced
   in Hydrus (e.g. `character:illya`) keep the `category:tag` shape,
   which monbooru honors.
3. Run the export into a folder.
4. Zip that folder. Either layout works: files at the zip root, or
   wrapped in one top-level subfolder.
5. Drop the zip into the import dialog.

What lands in monbooru:

- Each file keeps its filename and folder structure under the new
  gallery root. Hydrus names files after their SHA-256; on a Merge
  that hash is used to match entries against images you already have.
- Each sidecar's tags are attached to the image. Comment lines
  (starting `#`) and blanks are skipped. Namespaces are routed:

  | Hydrus namespace | Lands in monbooru as |
  |---|---|
  | `character:` | `character` category |
  | `creator:` | `artist` category |
  | `copyright:` | `copyright` category |
  | `series:` | `copyright` category |
  | `studio:` | `copyright` category |
  | `meta:` | `meta` category |
  | `medium:` | `medium` category |
  | `person:` | `person` category |
  | `year:` | `year` category |
  | any prefix naming a monbooru category (built-in or one you created) | that category |
  | bare token | `general` category |
  | any other prefix (`species:`, `title:`, ...) | the tag lands in `general` with the prefix dropped |

**Not preserved:** Hydrus URLs, its native rating services, notes,
file relationships, and any namespace monbooru has no category for
(the namespace is dropped and the bare tag lands in `general`).

## Blombooru

1. Open the Blombooru admin panel -> **Backup** -> **Download full
   backup**. You get a `.zip` with the manifest (`backup.json`), the
   tag list (`tags.csv`) and every media file.
2. Drop that zip into monbooru's import dialog.

What lands in monbooru:

- Each media file is extracted into the new gallery root under the
  same filename.
- Per-image tags are resolved through `tags.csv` and mapped by
  category:

  | Blombooru category id | monbooru category |
  |---|---|
  | 0 | general |
  | 1 | artist |
  | 3 | copyright |
  | 4 | character |
  | 5 | meta |
  | anything else | general |

- Blombooru's stored hash is used only to match entries against
  existing images on a Merge, and only when it is a SHA-256; older
  MD5 entries are ignored for matching.

**Not preserved:** albums, ratings, parent/child relations, mime
types, durations, and custom metadata.
