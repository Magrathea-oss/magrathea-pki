# Magrathea PKI Dataset

This directory contains the infrastructure for the replacement Magrathea PKI javaspec training corpus.

## Corpus reset

The previous corpus was intentionally discarded after domain quality regressions. Dataset episode numbering restarts at `0001`. No discarded episode, derived training view, incident, or preservation artifact remains part of the replacement corpus.

## Admission policy

Only episodes meeting all of the following conditions may be admitted:

- the trajectory is a sealed `RAW_EVENT_STREAM` captured directly from the `spec-driven` agent;
- chronological javaspec RED/GREEN evidence and required provenance are complete;
- for a new subject, the trace captures `javaspec describe <fully.qualified.Subject>` before the first specification or production-type edit;
- for a continuation slice of an already described subject, `javaspec describe` is not repeated.

Reconstructed summaries, story-driven or Cucumber-only work, unsealed traces, and traces without executable javaspec provenance are not dataset episodes.

## Layout

- `manifest.jsonl` — replacement-corpus manifest; initially empty.
- `schema/episode-v2.schema.json` — JSON Schema for structured episodes.
- `raw/v2/` — authoritative sealed raw episodes.
- `curated/sft-candidates/` — mechanically eligible candidate views pending independent approval.
- `curated/sft/` — independently approved SFT views.
- `evaluation/` — approved evaluation cases.
- `incidents/` — eligible incident records when admission policy permits retaining them.

Empty dataset directories are retained with `.gitkeep` sentinels.
