---
title: API and development
weight: 90
---

## UI password

Off by default: on a trusted home network the web UI is open. Enable it from
**Settings -> Authentication**, or by hashing a password on the command line
and pasting the result into the config:

```bash
# on the host:
./monloader -hash-password 'your-password'
# or via Docker:
docker exec -it monloader monloader -hash-password 'your-password'
```

Put the output in `auth.password_hash` and set
`auth.enable_password = true`. When enabled, the web UI is gated by a
session cookie (lifetime `auth.session_lifetime_days`, default 7); removing
the password clears every session.

## API tokens and scopes

monloader's JSON API lives under `/api/v1/` and requires a bearer token; the
API is disabled until at least one token exists. Create tokens in
**Settings -> Authentication**: each is named, individually revocable, and
its secret is shown once at creation, never again.

Each token's **config** dialog sets its scopes: `read` (list the queue,
inspect jobs, list sites) and/or `write` (enqueue URLs, manage jobs). A call
whose token lacks the needed scope gets `403 insufficient_scope`. Tokens
provisioned by [pairing](getting-started/pairing/index.md) have fixed scopes and
are removed by removing the pairing.

`/health`, `/api/v1/openapi.json`, and `/api/v1/docs` stay open without a
token.

```bash
curl -H "Authorization: Bearer <token>" \
     -X POST http://localhost:8081/api/v1/queue \
     -d '{"url":"https://danbooru.donmai.us/posts/xxx"}'
```

## API reference

The API documents itself in-app:

- HTML reference: `/api/v1/docs` (linked in the footer).
- OpenAPI spec: `/api/v1/openapi.json`.

## Error codes

A `failed` queue item carries one of these stable codes; scripts and the
monsender extension can branch on them:

| error_code | when |
|---|---|
| `unsupported_url` | gallery-dl matched no extractor for the URL, and it is not itself a direct link to a media file monbooru can ingest |
| `auth_required` | the site needs credentials (a 401/403 with a missing-auth message) |
| `blocked` | a bot-protection wall (Cloudflare / captcha challenge), kept distinct from `auth_required` so its 403 is not read as a missing credential |
| `rate_limited` | the site returned 429 / a rate-limit error |
| `network_unreachable` | gallery-dl could not resolve or reach the host (DNS failure, network unreachable); a refused/dropped connection stays `download_failed` |
| `download_failed` | any other non-zero gallery-dl exit (a reached host erroring, HTTP 4xx/5xx, a refused/dropped connection) |
| `mapping_failed` | metadata present but no usable file or URL could be built |
| `file_too_large` | monbooru rejected the upload for size |
| `monbooru_unreachable` | the push got no HTTP response (connect / timeout) |
| `monbooru_rejected` | monbooru returned a 4xx/5xx other than the duplicate 200 |
| `hash_mismatch` | a metadata refetch found the source no longer serves the file monbooru stored, so nothing was merged |
| `hash_not_found` | a hash lookup found no site (or the PTR index) holding the hash |
| `ptr_unavailable` | a PTR lookup was requested while the PTR backend is off; normally refused as a 409 when the lookup is enqueued |
| `canceled` | the job was canceled while the item was in flight |

The job's `summary` aggregates its items:
`{ created, duplicate, enriched, skipped, failed, canceled, total }`. The
outcomes themselves are described in
[downloading](guides/downloading/index.md#per-item-outcomes).

## Building from source

monloader is pure Go with no CGO, so the binary is static and builds without
system libraries:

```bash
make build      # go build with the version injected from VERSION.md
# or directly:
go build -o monloader ./cmd/monloader

./monloader -config /path/to/monloader.toml
```

`make build` injects the version and repository URL via `-ldflags` (read
from `VERSION.md` and `REPOSITORY.md`), which feed the footer and `/health`;
a plain `go build` reports `dev`.

CLI flags and subcommands:

- `-config` - path to the TOML config file (default `./monloader.toml`).
- `-hash-password '...'` - print a bcrypt hash for the UI password and exit.
- `-version` - print the version and exit.
- `healthcheck` - probe the local `/health` endpoint and exit non-zero if it
  is not healthy (accepts `-config` and `-timeout`).

### gallery-dl

The container image bundles Python and a pinned gallery-dl. Outside the
container you supply it yourself; if it is not on `PATH`, set
`gallerydl.binary_path` to its location. A missing binary is not fatal at
startup - the UI and API still run, the bundled version shows as
unavailable, and downloads fail until it is installed.

## Adding a site profile

Mappings are data, not code, so tracking gallery-dl's growing site list is a
data change. There are two levels:

- **No profile needed.** Any gallery-dl site without a curated entry uses
  the generic fallback ([sites](guides/sites/index.md)), and the
  `[[tag_overrides]]` / `[[rating_overrides]]` tables in `monloader.toml`
  ([mapping](guides/mapping.md)) can correct a generic site with no release.
- **A curated profile.** To improve a site's mapping, add one entry to
  `internal/mapping/profiles.json`, keyed by the gallery-dl category.
  Profiles are embedded at build time, so a new one ships with a rebuild.

A profile's fields:

| field | purpose |
|---|---|
| `family` | `danbooru`, `e621`, `moebooru`, `gelbooru_v02`, `philomena`, or `generic` - picks the rating semantics and the per-category tag regime |
| `kind` | `booru` (default) or `manga` - a manga gallery bundles its pages into one cbz |
| `post_url_template` | the canonical post URL with `{id}` substituted (e.g. `https://danbooru.donmai.us/posts/{id}`) |
| `md5_search_template` | the site's md5 search URL with `{md5}` substituted, a form gallery-dl's tag-search extractor matches (e.g. `https://danbooru.donmai.us/posts?tags=md5:{md5}`); set it to make the site eligible for hash lookup |
| `auth` | `none`, `api_optional`, `api_required`, or `cookies` - drives the settings login indicator |
| `example` | a representative URL for the per-site test probe |
| `category_overrides` | per-suffix tag-category remaps baked into the profile |
| `rating_overrides` | per-value rating remaps baked into the profile |
| `default_rating` | rating used only when the source gives none |
| `needs_tags` | a generic-family site that needs gallery-dl's `tags: true` to emit per-category tags (one extra request per post, e.g. sankaku) |
| `has_notes` | a generic-family site whose extractor emits note boxes with gallery-dl's `notes: true` (e.g. sankaku); the note-carrying booru families get it by family |
