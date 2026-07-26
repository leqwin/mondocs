---
title: Install
weight: 10
---

monsender runs on Firefox and Chrome.
You need a running monloader to send to; if you do not have one yet,
start with the [whole-stack quick start](../../quick-start.md).

## Firefox

Install from Mozilla Add-ons:
[addons.mozilla.org/en-US/firefox/addon/monsender](https://addons.mozilla.org/en-US/firefox/addon/monsender/)

This is the easy path: the add-on is signed and updates itself.

## Chrome

There is no Web Store listing; the Chrome build ships with each
release instead. Download `monsender-chrome-<version>.zip` from the
[releases page](https://github.com/monbooru/monsender/releases), unzip
it somewhere permanent, open `chrome://extensions`, switch on
**Developer mode** (top right), and point **Load unpacked** at the
unzipped folder. Updates are manual: download the next release's zip,
unzip it over the same folder, and hit the reload arrow on the
extension's card.


## Permissions at install

The install prompt is small on purpose: the extension asks only for
the ability to read the page you act on, run its scan there, store its
settings, and add a right-click menu entry. It gets no access to your
browsing history, downloads, or other tabs. Access to your monloader
server is granted separately, during [setup](setup/index.md), for that one
address only.

Next: [set it up](setup/index.md).
