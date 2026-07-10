# Magrathea PKI Dataset

This directory stores dataset material for Magrathea PKI agent-workflow maintenance and replay/curation work.

## Layout

- `0001-0033-*.jsonl` — preserved legacy raw V1 episodes. These files remain in their original repository paths and must not be rewritten during V2 maintenance.
- `manifest.jsonl` — one JSON object per dataset item. Legacy entries are marked `LEGACY_RAW_V1` and include preservation hashes, replayability, behavior-verification, quality, SFT, and evaluation eligibility fields.
- `schema/episode-v2.schema.json` — JSON Schema for future structured V2 episodes.
- `raw/v2/` — future raw V2 episode records only. Do not create episode `0034` without a future implementation handoff explicitly requesting it.
- `curated/sft/` — independently approved SFT training views derived from authoritative episodes.
- `evaluation/` — evaluation cases derived from approved episodes.
- `incidents/` — framework/model/specification failure records and incident analyses.
- `artifacts/` — external validation evidence and large supporting artifacts.

## Preservation rule

Legacy raw V1 episodes `0001` through `0033` are immutable source evidence. Maintenance tasks may add manifests, schemas, validation artifacts, and empty layout sentinels, but must not edit, move, or rewrite those legacy JSONL files.

## V2 admission rule

A future V2 episode must validate against `schema/episode-v2.schema.json` and must include provenance, environment, task, admission decision, raw observable events, patches, verification, termination, context metrics, curation, artifact references, and a resume capsule.
