---
title: Metadata mapping
weight: 30
---

gallery-dl returns each post's fields in the source site's own vocabulary.
monloader translates that into what monbooru expects: tags sorted into
categories, a rating, a source label, and a canonical URL. The translation
is driven by the curated site profiles plus a generic fallback, with
override tables in the config for the edge cases.

## Tags by category

monbooru sorts tags into categories (general, character, artist, copyright,
meta, medium, person, year, species). Boorus expose per-category tag lists, and each
list is routed to the closest monbooru category:

| Source tag category | monbooru category | Notes |
|---|---|---|
| general | general | |
| artist | artist | |
| character | character | |
| copyright | copyright | |
| meta / metadata | meta | gelbooru calls it `metadata` |
| species | species | |
| lore | meta | |
| contributor | artist | |
| circle / group | artist | doujin circle or group |
| parody / series | copyright | the parodied or source work |
| studio | copyright | production studio |
| model | person | real-person model (photo boorus) |
| faults (moebooru) | meta | |
| invalid, deprecated | dropped | not real tags |
| anything else | general | best-effort fallback |

Tag names are normalized to the form monbooru stores before they are
sent: lowercased, with spaces (and the two characters monbooru's search
reserves, `"` and `*`) folded to underscores and the ends trimmed
(`fate/grand order` becomes `fate/grand_order`).

monbooru auto-creates tags it has not seen before; any it rejects come back
as tag warnings, recorded on the queue item without failing the push.

## Rating

monbooru ratings are ordered general < sensitive < questionable < explicit.
The full-word forms (general, sensitive, questionable, explicit, and safe)
map one to one on every site, case-insensitively, with safe becoming
general.

The catch is the single letter `s`: on Danbooru it means "sensitive", on
every other family it means "safe". monloader knows which family each site
belongs to, so the letter is read per family, not globally. A rating value
it cannot recognize leaves the image unrated; monbooru keeps unrated images
visible under every rating ceiling, so an unknown value is treated as safe
to show.

**NSFW manga.** Manga and comic galleries carry no per-post rating. Leaving
them unrated would surface them under a safe ceiling, so the profiles of
NSFW-only sites (nhentai, hitomi, exhentai, and similar) set a
`default_rating` of `explicit` that applies only when the source gives no
rating. A real source rating always wins.

## Source, URL, and gallery

| monbooru field | Value |
|---|---|
| `url` | the post's own page. Curated sites build it from the profile's post URL template (e.g. `https://danbooru.donmai.us/posts/{id}`); a site without a profile uses the page link the extractor reports, falling back to the URL you submitted |
| `source` | the site name, so filtering by `source:danbooru` works in monbooru |
| `via` | `monloader`, recorded as the image's origin and as the tagger of each pushed tag |
| target gallery | the site's per-source gallery, falling back to the default gallery |
| `collection` / `collection_order` | the pool name and page order, when a pool is pushed as a collection |

A direct link to a media file has no booru post behind it: the source is the
file's host and the URL is the file URL itself. The exception is a direct
file sent along with the page it was found on (monsender does this): the
page becomes the recorded URL and its host the source, so the image links
back to where you actually saw it rather than to a bare CDN address.

## Commentary, original source, and notes

Danbooru-family posts carry the artist's commentary, and some families carry
positional note boxes overlaid on the image; both are pushed along, notes
with their pixel coordinates and reduced to plain text. Most boorus also
declare the post's original source - the upstream artist URL, such as a
Pixiv or Twitter page - and monloader pushes it as the origin's original
source, several entries joined one per line. monbooru overwrites a source's
commentary, original source, and notes on each re-pull.

## Parent posts

A post that declares a parent (a booru parent/child pair, such as an edit or
a variant set) is pushed with the parent's post URL. Once both posts are in
the monbooru gallery - whichever arrived first - monbooru links the pair as
a derivative relation, with the parent as the source. Pairs already related
(or marked not related) in monbooru are left alone.

## Override tables

When a profile's default is wrong for your library, override it in
`monloader.toml` (these tables are not exposed in the settings UI). An
override wins over the profile and takes effect on the next download:

```toml
# route a source tag category to a different monbooru category for one site
[[tag_overrides]]
site = "e621"
from = "species"
to   = "general"

# route a source rating value to a monbooru rating for one site
[[rating_overrides]]
site = "somebooru"
from = "x"
to   = "explicit"
```

`site` is the gallery-dl category. A `tag_overrides` entry matches a source
tag category (its `from`) and reroutes it; a `rating_overrides` entry
matches a raw rating value (case-insensitively) and remaps it. Either wins
over both the curated profile and the built-in family rule, so they also
cover a generic-fallback site that needs a tweak.

Giving a new site a curated profile of its own is a code change
(the profiles ship inside the binary); see
[API and development](../development.md#adding-a-site-profile).
