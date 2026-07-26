---
title: Sites and credentials
weight: 20
---

monloader does not parse any site itself; gallery-dl does. monloader ships
curated profiles tuned for known sites, and falls back to a generic
profile for anything else gallery-dl supports.

## Curated profiles and the generic fallback

- **Curated profiles** exist for 50-plus sites (boorus and manga/comic
  sites), listed on the Settings page in two tables. A profile knows the
  site's booru family (which decides how its tags and ratings are read), the
  canonical post URL, what kind of login it needs, and a representative
  example URL for the test probe.
- **Everything else** gallery-dl supports works through the generic
  fallback: per-category tags route by name where they match a monbooru
  category, ratings use tolerant rules, and the post URL is whatever
  gallery-dl reports. So a site works the day gallery-dl supports it; a
  profile only improves the result.

[gallery-dl's supported-sites list](https://github.com/mikf/gallery-dl/blob/master/docs/supportedsites.md)
shows the full list. How each site's metadata is translated is in
[metadata mapping](../mapping.md).

![The sites tables on the Settings page](settings-sites.png)

## Auth kinds

The **login** column on the Settings page shows what each site needs; a
marker flags a site missing a credential it requires.

| Auth kind | Shown in the login column as | Meaning | Examples |
|---|---|---|---|
| `none` | `none` | Reads without credentials | most boorus, most manga sites |
| `api_optional` | `api (opt)` | Works unauthenticated at low rates; a key raises rate limits | danbooru |
| `api_required` | `api key` | Refuses to read without a key | gelbooru, rule34 |
| `cookies` | `cookies` | Needs a logged-in browser session exported to a cookies file | sankaku, exhentai |

## Per-site setup

![A site's edit dialog](site-edit.png)

For each site you use, the Settings page exposes:

- **Credential fields** matching the family: an api key with a user id
  (gelbooru family), a username with an api key (danbooru and e621
  families), or a cookies file path. Secrets are write-only - the page shows
  whether a value is set, never the value itself.
- **A target gallery** dropdown, listing your monbooru galleries. Pushes
  from this site land there; leave it empty to use the default gallery.
- **Test** runs a live probe against the profile's example URL with your
  configured credentials, reporting ok, auth rejected, blocked, or failed in
  that row, with the underlying error on hover. A site still missing a
  required credential reads "needs cookies" or "needs api key"; a credential
  the site refuses reads "auth rejected"; a Cloudflare or captcha wall reads
  "blocked". The row also shows when the site was last reached successfully;
  that note is kept in memory and resets on restart.
- **Reset** drops the site's credential block, reverting it to the profile
  defaults.

Saving a site rewrites the managed `gallery-dl.json` from the config; that
file is never hand-edited.

## Cookies files

For a `cookies` site, export your logged-in browser session as a
`cookies.txt` file and place it under the cookies directory
(`/config/cookies` by default). Set its path in the site's Settings row, or
directly in the TOML:

```toml
[[sites]]
name    = "sankaku"
cookies = "/config/cookies/sankaku.txt"
gallery = "default"
```

## The equivalent TOML

The Settings rows write `[[sites]]` blocks in `monloader.toml`; you can edit
them directly instead. `name` is the gallery-dl category:

```toml
[[sites]]
name         = "gelbooru"   # gallery-dl category
api_key      = ""
user_id      = ""
gallery      = "art"        # per-source target; empty = default gallery
lookup_order = 4            # lookup-chain position; 0 or absent = not queried
```

`lookup_order` decides whether (and when) the site is searched when finding
tags by hash; the chain is edited from the Settings lookup section and
explained in [reverse lookup](../lookup/index.md). The rest of the file is covered in
[configuration](../../configuration.md).
