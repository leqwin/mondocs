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
unless monloader is paired with its PTR sync turned on. While the
index is still catching up, a note warns that the diff may overstate
what is new, and the **contribute...** button stays disabled until
the sync finishes. Sending anything also needs a
personal contribution account created on monloader's PTR page.

## From an image

The **Public Tag Repository contributions** panel under the tag
editor tells you how many of this image's tags are new to the PTR,
and how many tags the PTR holds that the image does not. For the
second case the panel also offers **Pull tags**, covered in
[Lookup](../lookup/index.md).

**contribute...** opens a dialog with two lists:

- **add** lists the tags the PTR does not have yet. A row notes "PTR
  spelling: ..." when the PTR's spelling differs from yours because
  of how monbooru and hydrus handle tags (the PTR stores
  `creator:1nupool` where monbooru says `artist:1nupool`). A row
  noting "not a PTR tag" is a spelling the PTR holds nowhere, not just
  missing from this file: sending it creates a brand new PTR tag, so
  check first whether the PTR already knows the thing under another
  name (the tag's detail page can tell you, see below). Tags
  the PTR already has, and tags it cannot take, fold away under
  one-line summaries.
- **petition removal** lists tags the PTR carries for this file that
  your image genuinely lacks. Alternate spellings of tags you already
  have, and tags your image shows through an implication, are filtered
  out - what remains really is extra. An absent tag can still just
  mean you have not tagged it locally: tick one only if it is
  factually wrong for the image, and give a reason. One reason covers
  everything you tick, and petitions have no `[all]` on purpose: each
  one is an individual claim. Shift-click ticks a range.

**send to PTR** contributes it under your account, and the dialog
turns into a receipt: what was staged, and what was refused with the
reason. Tag adds apply to the PTR right away; petitions go to the
PTR's volunteer moderators (janitors) with your reason, and cannot be
taken back once sent.

A manga or archive row shows no panel: its file hash is unique to the
bundle monloader built, so no other PTR user's files could ever match
it.

## From a tag

A tag's detail page carries the same panel, but for relations instead
of tags, in both directions of both kinds: aliases pointing at the
tag or the tag resolving to another, implications out of it or into
it.

The PTR may know your tag under another name. You might have named a character `samus_aran_(metroid)` where the PTR files her as `character:samus aran`. So the panel also asks about every alias pointing at the tag, and when one of those is what the PTR knows, the panel says so ("known to the Public Tag Repository as samus_aran, an alias here")
and works through that name: **Pull aliases and implications** brings that cluster in, and the petition list shows the PTR's relations for it. When neither the tag nor any alias is known, the panel says "the Public Tag Repository does not know this tag" first. Contributing new relations would start a new PTR cluster beside one that may already exist. In between those two there is a third case: the repository has your spelling but nothing
filed under it, which reads "the Public Tag Repository holds no
relations for this spelling".

**[look up as...]**, top right of the panel, is for the case where the PTR files your tag under a name you have not declared as an alias yet.
It opens on a list of the spellings the PTR actually holds near your tag's name, each with what its cluster carries, so you can pick one. Pick a row, or type a spelling and press Enter,
and the dialog shows what the PTR
holds under it and what a pull would do: `+` rows are aliases and
implications that would land on your tag, dim rows are already
declared, `!` rows are left alone (a name that is already a tag of its
own here, or an alias of another tag). The looked-up spelling itself
becomes an alias of your tag when the name is free, so from then on
the panel finds the PTR on its own.

Its **contribute...** dialog works the same way:

- **suggest** lists the relations you declared, written as arrows -
  `blond_hair -> blonde_hair` for an alias, `tohsaka_rin =>
  fate/stay_night` for an implication. The ones the PTR does not know
  get a checkbox; the ones it already holds fold away, and anything
  awaiting review shows as "already suggested".
- **petition removal** lists relations the PTR holds for this tag
  that you have not declared, and only when you also hold the tag on
  the other end; tick the ones that are wrong.

Suggestions and petitions both need a short reason; the janitors read
it when they review. The dialog only syncs what your catalog declares:
manage the tag in monbooru first, then contribute the result.

## What happens after

monbooru hands your contribution to monloader, which uploads it and
keeps the record. To see the history - what was applied, what a janitor
approved or removed, what is still pending - open monloader's PTR page;
each row links back to the image or tag in monbooru. Tag adds you made
can be rescinded there (monloader petitions them back off); suggestions
and petitions cannot, which is why the dialogs warn you before you
send.
