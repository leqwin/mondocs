---
title: Contributing to the PTR
weight: 100
---

The Hydrus Public Tag Repository is a shared, community-maintained tag database.
monloader can sync a copy of it to answer tag lookups offline (see the
[PTR guide](../../addons/monloader/guides/ptr/index.md)). Once you have
a personal PTR account, monbooru also lets you contribute: push tags your
images carry that the PTR lacks, and petition tags that are wrong.

Everything here reaches the PTR through monloader, so nothing shows
unless monloader is paired with its PTR sync turned on. The panels
appear as soon as the sync starts: while the index is still catching
up, a note warns that the diff may overstate what is new (a tag can
look missing simply because its part of the copy has not arrived yet),
and the **contribute...** button stays disabled until the sync
finishes. Sending anything also needs a personal contribution account
created on monloader's PTR page; without one the button stays
disabled too.

## From an image

Open an image. Under the tag editor sits an indigo **Public Tag
Repository contributions** panel. It tells you at a glance how many of
this image's tags are new to the PTR, and how many tags the PTR holds
that the image does not. For the second case the panel also offers
**Pull tags**, which fetches them in - that direction is covered in
[Lookup](../lookup/index.md).

**contribute...** opens a dialog with two lists, add over petition:

- **add** lists the tags the PTR does not have yet, each with a
  checkbox. Tick a row to suggest to add a tag. A row notes "PTR spelling: ..."
  when the PTR's spelling differs from yours because of difference in how monbooru and hydrus handle the tags (the PTR stores
  `creator:1nupool` where monbooru says `artist:1nupool`). Tags the PTR
  already has, and tags it cannot take, fold away under one-line
  summaries so a long list stays readable.
- **petition removal** lists tags the PTR carries for this file that
  your image genuinely lacks. Alternate spellings of tags you already
  have, and tags your image shows through an implication, are filtered
  out - what remains really is extra. An absent tag can still just
  mean you have not tagged it locally: tick one only if it is
  factually wrong for the image - a red `-` marks it - and give
  a reason. One reason covers everything you tick.

Nothing is ticked when the dialog opens. Each list scrolls on its own
under a header that keeps count ("add - 12/38"). `[all]` and `[none]`
tick or clear a whole list, and shift-click ticks a range. Petitions
have no `[all]` on purpose: each one is an individual claim.

A line beside the send button sums up exactly what you are about to
ask ("asks to add 2 tags and petition the removal of 1 tag").
**send to PTR** contributes it under your account, and the dialog
turns into a receipt: what was staged, and what was refused with the
reason. Tag adds apply to the PTR right away; petitions go to the
PTR's volunteer moderators (janitors) with your reason, and cannot be
taken back once sent.

A manga or archive row shows no panel: its file hash is unique to the
bundle monloader built, so it would only pollute the shared database.

## From a tag

A tag's detail page carries the same square at the bottom of its right
column, but for relations instead of tags, and in both directions of
both kinds: aliases pointing at the tag or the tag resolving to
another, implications out of it or into it.

Its **contribute...** dialog works exactly like the image one:

- **suggest** lists the relations you declared, written as arrows -
  `blond_hair -> blonde_hair` for an alias, `tohsaka_rin =>
  fate/stay_night` for an implication - each labelled with its
  direction. The ones the PTR does not know get a checkbox; the ones
  it already holds fold away, and anything awaiting review shows as
  "already suggested".
- **petition removal** lists relations the PTR holds for this tag
  that you have not declared, and only when you also hold the tag on
  the other end (a relation to a tag you have never seen is not one you
  can judge) - tick one only if it is actually wrong.

Suggestions and petitions both need a short reason; the janitors read
it when they review. The dialog only syncs what your catalog declares:
manage the tag in monbooru first - the detail page's relation sections
each have an inline add, so aliases and implications in both
directions are one input away - then contribute the result.

## What happens after

monbooru hands your contribution to monloader, which uploads it and
keeps the record. To see the history - what was applied, what a janitor
approved or removed, what is still pending - open monloader's PTR page;
each row links back to the image or tag in monbooru. Tag adds you made
can be rescinded there (monloader petitions them back off); suggestions
and petitions cannot, which is why the dialogs warn you before you
send.
