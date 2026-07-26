---
title: Sources and notes
weight: 105
---

Every image can carry a record of where it came from and what you know
about it. All of it is edited from rows on the detail page, in the right side panel and below the
image.

## Sources

![The Sources rows and the panel a source expands into](sources.png)

A source is a link to where the image exists online - a booru post, an
artist page. An image can carry several; monloader pushes and
[lookups](../lookup/index.md) add them automatically, and **[+ add]**
records one by hand.

Each source is two lines: the source and its match hints with
**[open]** on the first, the actions beneath. The actions are
**[edit]**, **[refresh]** (re-pull the post's tags, commentary and
notes through monloader - see [Lookup](../lookup/index.md)),
**[upgrade]** (shown when the source serves a different file than
your local copy; replaces the file in place - see
[Lookup](../lookup/index.md#running-lookups-from-monbooru)), and
**[x]** to remove it. **[set primary]** picks which source leads the
list and provides the image's headline source label.

A source expands into its own panel holding two more fields pulled
from booru posts (or edited by hand):

- **Original** - the artist's own upload the booru post points at
  (a pixiv or twitter link, typically).
- **Commentary** - the artist's title and description as the booru
  recorded them.

## Personal note

A free-text note on the image, for you only (shortcut `e n`).

![The personal note and annotations under the image](note.png)

## Annotations

Annotations are positioned boxes drawn on the image with a text each (the way boorus annotate translation bubbles). Booru lookups import the
post's notes as annotations; you can also draw your own from the
detail page. They render as hover overlays on the image.

The note and your own annotations sit under the image; annotations a
booru lookup pulled in stay on their source's panel. Hovering an
annotation in either list highlights its box on the image, and
**[hide annotations]** clears the overlay.

## Which sources gave a tag

The tag list under the image groups tags by category. When more than
one source agreed on the same tag - say you added it and a later booru
refetch confirmed it, or a PTR lookup pulled it in too - the tag shows
a small **+N** beside it. Hover it to see every source and the date it
last confirmed the tag. A tag still renders once, under whichever
source added it first; the +N just tells you who else agrees.

A refetch never deletes tags. When a source stops listing a tag it
contributed earlier, the tag moves to a **Stale tags added by ...**
group so you can see it is no longer part of that source's current
state and remove it yourself if you agree. If a later refetch lists it
again, it moves back under the source's regular group.

Any group holding more than one tag carries a **[×]** next to its
heading, which removes that group and nothing else - clearing a
stale group leaves the same source's current tags in place.
