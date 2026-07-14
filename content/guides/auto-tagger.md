---
title: Auto-tagger
weight: 50
---

The auto-tagger runs ONNX image-tagging models locally against your
collection and applies the tags they suggest. Nothing is sent
anywhere: inference happens on your own CPU or GPU. It is disabled by
default.

Auto-tags are kept apart from your own: they carry the tagger's name,
show in their own group on the detail page, and can be stripped per
tagger later without touching manual tags.

## Install a tagger from the catalog

1. Open **Settings -> Auto-Tagger**. The table lists the suggested
   models: WD14 SwinV2, JoyTag, Camie v2.
2. Click **Show instructions** on the row you want. The dialog has
   shell snippets for both a host install and a `docker exec` install.
3. Run the snippet on a machine with internet access. It drops the model files into the
   `models` volume.
4. Refresh the Settings page and tick **Enable** on the row.

You can also bring your own ONNX model; that is covered in
[Configuration](../configuration.md#custom-onnx-models).

## Thresholds and per-category caps

Each tagger has a global confidence threshold: predictions scoring
below it are dropped. Click **Configure** in a tagger's Thresholds
column to tune it, and per category:

- **Threshold** overrides the global threshold for that category. For
  example, raise `character` to 0.85 to suppress false-positive
  character tags while keeping `general` permissive. Empty cells fall
  back to the global value.
- **Max tags** caps how many tags the tagger may emit for that
  category on one image, keeping the highest-scoring ones. Empty cells
  use the built-in defaults (`character` 8, `copyright` 4, `artist` 4,
  `general` 25, `rating` 1, anything else 10); `0` means uncapped.
- **Enable** mutes a category entirely when unticked: the tagger emits
  nothing for it regardless of score. Useful to run a tagger for only
  the categories you want.

When several taggers are enabled they all run and their results are
merged: a tag detected by two taggers is inserted once, with the
higher confidence.

## Per-gallery scope

Each tagger row has a Galleries column with its own **Configure**
button. The default is all galleries; tick individual galleries to
restrict it. Useful when one gallery holds anime art and another holds
photos and you do not want an anime-trained model firing on the
photos.

## Running it

- **One image:** the **Auto-tag** button next to the tag editor on the
  detail page. Single-image runs always use the CPU, even with GPU
  enabled (loading a model onto the GPU for one image would take
  longer than the tagging).
- **A selection:** check thumbnails in the gallery and pick
  **Auto-tag** in the batch bar.
- **A whole search:** the gallery's **Actions** chooser -> Auto-tag
  applies to every match of the current search. To catch up on
  everything the tagger has not seen, run it on `autotagged:false`.
  A search matching more than 50,000 images is refused; narrow the
  query and run in slices.
- **Nightly:** turn on **Run enabled auto-taggers** in
  **Settings -> Schedule** for a daily pass (off by default).

The first run after a while takes a few extra seconds while the model
loads; batch runs show progress in the status bar and can be
cancelled.

## Videos and archives

A video is tagged from 5 sampled frames, a comic archive from every
page, and the per-frame results are merged into one set of tags for
the whole item. A label must show up on more than one frame to
survive the merge (scaled with length and capped at 10 frames), so a
single noisy hit on a 200-page manga is not enough while a label seen
on 10+ pages lands. The confidence threshold then applies to the
label's mean score. This gate is tunable via the
`tagger.aggregation.min_hit_fraction` TOML knob; see
[Configuration](../configuration.md).

## Going further

GPU (CUDA) setup, worker counts, custom ONNX models with a
`tagger.json` sidecar, remapping model labels with `dispatch.json`,
and the tagger's memory behavior (idle release, subprocess backend)
are covered in [Configuration](../configuration.md).
