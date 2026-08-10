---
title: Plugins
weight: 100
---

monloader and monsender are first-party addons: monbooru knows what
they are and drives them. A plugin is the open version of the same
idea. It is any program you run that pairs with monbooru,
holds a scoped API token, and gets a few buttons in monbooru's
interface. Nobody has to add anything to monbooru for yours to work,
and it can be written in any language.

What a plugin can do is deliberately narrow on monbooru's side and
wide open on its own:

- it reads and writes your library through the same REST API monloader
  uses, so it can do anything an API client can;
- it gets **buttons** in two places (on an image's page and under the gallery's batch action bar);
- it can host its own pages, in its own style, doing whatever it likes.

What it cannot do is inject anything into monbooru's own pages. A
button is a text label, escaped and server-rendered. Everything richer
lives on the plugin's own site.

## The two kinds of button

A button either **relays** or **opens**.

A relay button: You click it, monbooru sends the
plugin the images in scope (the one you are looking at, or everything
you have selected), waits up to ten seconds, and shows you the message
the plugin sends back. If the plugin says it changed the files, the
page reloads so you see the result, keeping your selection so you can
run it again on the same images.

An open button shows you a page the plugin serves, in a pop-in over
the page you were on, with the image id, the gallery name and the
address you came from filled into its URL. This is the mode for anything that needs a
real interface: a crop tool, an artist database, a tag editor of your
own design. When the plugin is finished it sends you back where you
came from, and the pop-in closes onto a freshly loaded page.

Either kind can say what it works on. A plugin that edits pictures
declares itself picture-only, and monbooru then keeps its buttons off
your videos, animations and comic archives entirely, and leaves those
out of a batch selection instead of sending them over to fail. When
that happens the flash says so - "2 of 3 sent; 1 not handled by
xxx" - so a batch never quietly does less than you asked.

monbooru serves that page itself, at `/plugins/<name>/`, rather than sending your browser at the plugin. Serving it through monbooru means it opens wherever monbooru
does, with nothing extra to configure.

## Installing one

If the plugin ships as a folder, installing is dropping it in
`plugins/` next to `monbooru.toml`: its row appears under
**Settings -> Plugins** disabled, and nothing runs until you enable
it (monbooru shows the exact command it is about to run first).

A folder brings everything it needs with it. monbooru installs nothing and provides no interpreter, so a folder is normally one self-contained program.

## Plugins registry

The [monbooru-plugins registry](https://github.com/monbooru/monbooru-plugins)
lists plugins and themes people have published. Listing
there is not a review: assume nothing in it has been verified, and every entry has to link its source so you can read it. Bugs in a plugin belong on that plugin's own tracker.

## Writing one

A plugin is an HTTP service. It needs at most three things:

- `GET /health` answering 200, which is what monbooru probes at
  approval time and to decide whether to show your buttons. Answering
  `{"version": "..."}` puts your version on the settings row;
- a handler for the relay POST, if you declared relay buttons. It
  receives `{payload, monbooru, gallery, slot, button, image_ids}` with
  your token as a bearer header, and answers
  `{"ok": true, "message": "...", "refresh": true}`;
- whatever pages your open-mode buttons point at, with relative links
  inside them so they still work one path deep.

Give a button `media` when it does not cover everything: any of
`image` (jpeg, png, webp), `archive` (cbz and zip) and `animated`
(gif, mp4, webm), comma-joined. monbooru will not render it on
anything else, and strips the rest out of a selection before relaying
it, telling the operator how many rows it dropped. Leave it out and
you get every image.

Everything else you do through monbooru's REST API with the token you
were issued. Pairing itself is boilerplate: post to
`/api/v1/pair/request` with your name, address, the permissions you
need and the buttons you want, poll `/api/v1/pair/status` until the
user approves, store the token you get back. Ask for read and
write; ask for delete only if your plugin genuinely deletes images.

To ship it as a drop-in folder, add a `plugin.toml` naming the launch
line: `command = "./yourplugin"`, and optionally `command_windows` /
`args_windows` when the other OS needs a different one. 

Changing your declared buttons in a later release means re-pairing -
you offer again and the operator approves a request marked **re-pair** -
because those buttons are what they agreed to. Offering again is also
what a replaced install should do: a copy that no longer has its
credentials is not paired, whatever monbooru still has on file.

What monbooru tries not to break: the `/api/v1` API, the pairing
exchange, the relay message shape, the substitution variables, the button slots, the mount your open-mode pages are served under, and the
theme variables.
Templates, `/internal/` URLs and the database schema are none of those and may break in future releases. There is no monbooru
version to declare compatibility with, you build against the contracts,
and the API's version is in `/api/v1/openapi.json`.

The registry's
[`examples/simple-edit`](https://github.com/monbooru/monbooru-plugins/tree/main/examples/simple-edit)
is a working plugin to copy: it pairs, rotates images through a relay
button, and serves its own crop page behind an open-mode one.
