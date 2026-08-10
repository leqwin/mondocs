---
title: Addons
weight: 95
---

monbooru is the main application: it owns your images and their tags, on your
disk, in one SQLite file per gallery. By design it makes no network
requests of its own, so your collection and your browsing stay
entirely local. You can run it alone forever: nothing in monbooru
depends on the other apps being present.

The addons exist so monbooru can stay offline while you still get
online features. You add them when you want them:

**[monloader](monloader/_index.md)** connects to the internet on monbooru's behalf. When you want
something from the web - download a post from a booru site, look up
where an image came from, pull tags for a file you already have -
monbooru asks monloader, and monloader does the online part. It
downloads with gallery-dl, translates each site's metadata into
monbooru's tags and ratings, and pushes the result into a gallery.
Features in monbooru that need it (lookups, refreshing sources) stay
hidden until a monloader is connected.

**[monsender](monsender/_index.md)** adds a send button to your
browser, once monloader is in place. You are looking at a page; you
press the toolbar button; the page lands in monloader's queue and,
once downloaded and mapped, appears in monbooru with its tags.

**[Plugins](plugins.md)** are the open version of the same idea:
anything you or someone else writes, showing up as a few buttons in monbooru.

The apps connect by [pairing](pairing.md): each link is approved once
in the receiving app's settings, and the apps exchange scoped API
tokens on their own. The [quick start](quick-start.md) walks through
adding both addons to a running monbooru.
