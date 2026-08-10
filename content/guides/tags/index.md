---
title: Tags
weight: 20
---

## Adding tags to an image

Type tags into the input on the detail page, separated by spaces.
Wrap a multi-word tag in double quotes to fold its spaces to
underscores, and prefix with a category to file the tag there:
`artist:"john doe" blue_eyes 1girl` adds `john_doe` as an artist tag
and the other two as general tags.

Tag names are lowercase, up to 200 characters, and accept most
characters (accented letters, CJK, punctuation) except space, `"` and
`*`, which belong to the search syntax. `girls'_frontline`,
`fate/grand_order` and `東方project` all work.

To tag many images at once, use **Add tags manually** in the
gallery's Actions chooser (applies to the whole current search) or in
the batch bar (applies to the checked thumbnails). **Remove tags** on
the same surfaces strips tags by name, by source, by auto-tagger, or
wholesale.

## Reading an image's tags

The sidebar lists the image's tags grouped by category, metadata
first (rating, year, meta, medium), then what is in the image
(artist, character, and the rest, with general last), alphabetically
within a group so a tag is where you expect it.
Each row is `[x] tagname  marker  count`: the `[x]` takes the tag off
the image, the name searches for it, and the count is how many images
in the library carry it. Hovering a name spells it out in full (long
ones are cut to fit) along with any other spellings aliased to it. Each
category heading has its own `[x]` that clears the whole category after
a confirmation.

The marker between the name and the count is one of three:

- `stale`, with the name struck through: the source that gave you
  this tag no longer lists it. The tag stays on the image until you
  decide; a `remove all` link at the bottom of the list clears every
  stale tag in one go.
- `87%`: an auto-tagger is the only thing vouching for this tag, and
  that is how sure it was. The percentage goes away once you or a
  booru also apply the tag.
- `x3`: three sources agree on this tag. Hover to see which, and when
  each one applied it.

Tags that arrived through an implication (you added `hatsune_miku`,
so `vocaloid` came with it) sit indented and dimmed under the tag
that brought them, and leave when it does, so they carry no `[x]` of
their own. Hovering one names the tag that brought it.

Under the input, **Just added** echoes the tags this session put on
the image.

The **[categories] / [sources]** switch at the top of the list regroups
it by who applied each tag instead of by category: you first, then the
boorus, then the auto-taggers. A tag several of them agree on is listed
under each one, so you can read who agrees on what. In this view an `[x]`
withdraws that source rather than deleting the tag: a tag another
source also applied stays on the image and just leaves this group, and
only goes for good once the last source vouching for it is dropped.

Pressing `r` starts keyboard tag editing: the arrows move through the
list, Enter removes the highlighted tag, Escape stops.

## The Tags page

![The Tags page](tags-page.png)

The Tags page is the catalog view: every tag, with its category,
usage count and controls. Points that are not obvious from the
controls themselves:

- **Rename** can keep the old name as an alias, so searches built on
  the old spelling keep working.
- **Alias to** moves the selected tags' images onto the canonical tag
  and leaves the old names behind as zero-usage aliases. **Merge** is
  the same operation among the selected tags themselves: pick the
  survivor, the rest become its aliases.
- Implied tags (declared with **Imply**, or edited on the tag detail
  page) are real tags for search purposes.
- **Find aliases and implications** (shown when a paired monloader
  has the Hydrus PTR enabled) pulls each selected tag's known
  relations from the Public Tag Repository into your catalog. Nothing
  is removed or sent. A re-run also reconciles earlier pulls:
  relations the PTR no longer lists move under a stale heading on the
  tag detail page, for you to drop if you agree. See
  [Lookup](../lookup/index.md).

In the sidebar's search box, plain text matches from the start of the
name and `*` matches anything anywhere: `kimono` finds `kimono_dress`
but not `black_kimono`, while `*kimono*` finds both.

Two sidebar filters are not obvious from their labels:

- **Stale** finds tags a source dropped on its last refresh: **Has
  stale** for any dropped usage, **Fully stale** for tags whose every
  use was dropped (safe to delete).
- **Used by** answers "what does this booru actually tag with", where
  the **Origin** column only answers "what did it introduce": a tag
  danbooru invented and gelbooru later used reads danbooru under
  Origin and both under Used by.

**Folded duplicates** cleans up tags an older pull stored folded
(before monbooru accepted the full character set), like
`fate_grand_order` where the source really has `fate/grand_order`.
Refresh the affected images so the corrected spelling arrives, run
**Find folded duplicates** from Settings -> Maintenance, then open
the filter: it lists each old spelling next to the corrected tag, and
**Merge into corrected spelling** collapses the ones you pick (the
old name stays as an alias).

On a tag's detail page, the aliases and "implied by" lists group by
whoever declared each entry, and a group's **[x]** drops the whole
group in one go - the way to undo a PTR pull or one source's
relations without clicking them off one at a time.

Tags are never deleted automatically: removing a tag's last image
leaves the catalog row at zero usage. Delete rows explicitly from the
Tags page when you want them gone.

The **Categories** page manages the categories themselves. Built-in
categories can be recolored but not renamed or deleted; custom ones
can be renamed, recolored and deleted.

## Ratings and the SFW ceiling

Each image carries at most one rating tag, from a fixed set ranked
`general < sensitive < questionable < explicit`. Adding a rating by
hand replaces whatever was there, even when the new level ranks below
the old one: your choice always wins, including over an auto-tagger's.

The four names are fixed: you cannot rename one, move it, or fold it
into another tag. You can go the other way and alias an ordinary tag
onto a rating, which is how you clean up a library that arrived with
its own spelling for the same thing - a `safe` or `nsfw` tag from an
import, or a leftover `meta:explicit`. Select it on the Tags page,
use **Alias to** with `rating:explicit` as the target, and its images
pick up the rating. Images already rated higher keep the level they
had, so folding a tag in never makes something visible that your
ceiling was hiding. Only the four canonical names are protected: any
other tag sitting in the rating category is an ordinary tag you can
rename, move or fold.

The footer carries the **SFW ceiling**: click a rating level to hide
every image ranked above it. The ceiling follows you across pages and
applies to gallery browsing, related images, batch operations on the
current search, and auto-tag runs, so an action scoped to "the
current search" can never touch images you cannot see. Setting it
back to `explicit` turns it off.
