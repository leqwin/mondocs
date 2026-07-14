---
title: AI metadata
weight: 40
---

If you generate images with Stable Diffusion tools, monbooru reads the
generation parameters they embed and makes them browsable and
searchable. Extraction runs automatically at ingest for PNG, JPEG and
WebP files; images without metadata are ingested without it.

## What is read

**A1111 / Forge** parameters are read from the PNG `parameters` text
chunk, the JPEG EXIF `UserComment` field, or the WebP EXIF chunk.
monbooru parses the positive and negative prompt plus the parameter
line: steps, sampler, CFG scale, seed, model and LoRA hashes. The full
parameter line is kept as well.

**ComfyUI** workflows are read from the PNG `prompt` chunk (the API
format) with the `workflow` chunk as a fallback. monbooru follows the
node graph to pull out the prompt, seed, steps, CFG, sampler,
scheduler, checkpoint and LoRAs, and stores the complete workflow
JSON.

An image can carry both at once (for example a ComfyUI render
post-processed through Forge); `ai:any` matches either.

## Where it shows

The detail page renders a **Generation data** block: prompt, negative
prompt, model, sampler, seed and the rest, with the full raw
parameters or workflow available underneath.

At the top of the block sits the **generation hash**, a short
fingerprint of the recipe (prompt, negative prompt, model, sampler,
steps, CFG - deliberately not the seed). Every image generated from
the same recipe shares the hash, so clicking it lists all your
re-rolls of that prompt together.

## Searching on it

The related filters (`ai:`, `prompt:`, `model:`, `sampler:`, `seed:`,
`generated:`) are documented in
[Searching](searching/index.md#ai-and-generation-metadata). A couple of
examples:

- `ai:comfyui model:sdxl` - ComfyUI images made with an SDXL
  checkpoint.
- `prompt:catgirl seed:12345` - that one render you remember the seed
  of.

## Re-extraction

If you add files that were indexed before, or a monbooru update
improves the parser, run **Settings -> Maintenance -> Re-extract
metadata** to re-run extraction across the library. See
[Maintenance](maintenance.md).
