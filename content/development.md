---
title: Development
weight: 90
---

## Password login

The web UI has no login by default - fine on a trusted home network.
To add one, enable it via **Settings -> Authentication**, or set
`auth.password_hash` and `auth.enable_password = true` in the TOML.
To generate the hash:

```bash
# On the host:
./monbooru -hash-password 'your-password'
# Or via Docker:
docker exec -it monbooru monbooru -hash-password 'your-password'
```

Logins are rate-limited per IP with exponential backoff.

## REST API

The API is disabled until you create at least one API token in
**Settings -> Authentication**. Tokens are named and individually
revocable, and each carries a privilege set chosen in its **Config**
dialog:

- `read` - all `GET` endpoints (search, fetch, tags, ...)
- `write` - `POST`/`PATCH` (upload, edit, tags, relations, ...)
- `delete` - `DELETE` endpoints

The secret is shown once at creation and stored only as a hash.

```bash
curl -H "Authorization: Bearer <token>" \
     "http://localhost:8080/api/v1/images/search?q=1girl"
```

Error codes to expect:

- `401 unauthorized` - missing or invalid token.
- `403 insufficient_scope` - the token's scopes do not cover the
  method.
- `503 api_disabled` - no API token exists yet (also returned when no
  gallery is active).

Requests target the active gallery by default; add `?gallery=<name>`
or an `X-Monbooru-Gallery` header to address another one.

### API reference

The endpoint reference lives in the app itself and is always in sync
with the running version:

- HTML reference: `/api/v1/docs` (also linked in the footer).
- OpenAPI spec: `/api/v1/openapi.json`.

Those two are the source of truth for the wire shapes; this site does
not duplicate them.

## Pairing with monloader

To connect monloader you do not copy tokens by hand: monloader asks,
you approve under **Settings -> Plugins**, and both sides exchange
scoped tokens automatically. The pairing model is described in
[Pairing](addons/pairing.md).

## Building from source

```bash
# CPU only, no auto-tagger:
go build -o monbooru ./cmd/monbooru

# With auto-tagger (requires the ONNX Runtime shared library):
CGO_ENABLED=1 go build -tags tagger -o monbooru ./cmd/monbooru

./monbooru -config /path/to/monbooru.toml
```

A first run with no config file writes one full of defaults meant for
the Docker image (`/gallery`, `/data`, `/models`). Outside a container
those paths usually do not exist, so the first start fails and the log
points you at the file it wrote: edit `gallery_path`, `data_path` and
(optionally) `model_path` for your host and run it again.

For the `-tags tagger` build, `libonnxruntime.so` must be reachable:
on `LD_LIBRARY_PATH` or in `/usr/lib`, or pointed at with the
`ORT_LIB_PATH` env var (absolute path to the `.so`). The Docker image
bundles ORT v1.21.0 and needs none of this.

## CLI flags and subcommands

- `-config` - path to the TOML config file.
- `-hash-password` - print a bcrypt hash of the given password and
  exit.
- `healthcheck` - probe the local `/health` endpoint; exits 0 when
  healthy. Used by the Docker healthcheck.
