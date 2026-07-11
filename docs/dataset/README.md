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
- `raw/v2/` — authoritative sealed raw episodes.
- `curated/sft-candidates/` — mechanically eligible candidate views pending independent approval.
- `curated/sft/` — independently approved SFT views.
- `evaluation/` — approved evaluation cases.
- `incidents/` — eligible incident records when admission policy permits retaining them.

Empty dataset directories are retained with `.gitkeep` sentinels.

## Reinforcement-learning sidecars

RL evidence is additive. It never edits, replaces, reclassifies, or infers new
facts for a V2 episode or its SFT view. Episodes `0001`–`0004` remain accepted
`RAW_EVENT_STREAM` records and `CURATED_SFT_CANDIDATE` views, with their existing
classifications unchanged. They are **not retroactively RL-ready**: their traces
do not contain the independently approved state/action/reward and partition
evidence required by the RL contract. No reward, preference, hidden-evaluation,
or alternative-execution data has been fabricated for them. The prior no-edit
capability audit is not an RL episode.

Future RL records are sidecars under `rl/v1/`:

- `sidecars/` — admitted sidecars that reference one sealed V2 episode and its
  events, metadata, and seal by SHA-256;
- `quarantine/` — schema-valid or diagnosable records that are not admitted;
- `artifacts/` — retained sidecar evidence such as deterministic verifier output;
- `preferences/` — retained evidence for preference groups. A preference group
  is admissible only when every alternative is a distinct, genuinely executed,
  sealed trajectory; generated or hypothetical alternatives are forbidden.

A sidecar records ordered state/action/observation steps and exact environment,
tool-registry, Git, and pre-baseline javaspec-launcher provenance. Task outcome,
environment outcome, and agent-policy outcome are evaluated separately. Typed
stops are retained; `FRAMEWORK_INCOHERENCE` is attributed to `JAVASPEC` by the
schema. Reward events may be deterministic, human-produced, or independently
AI-produced, but always carry producer/version/evidence provenance and a
separate approval. The implementation agent (`spec-driven`) is not an allowed
reward producer, approver, policy evaluator, partition authority, or admission
decider, and a producer cannot approve its own reward.

Privacy controls cover secrets, private machine paths, training/evaluation
leakage, explicit redactions, and protection of hidden evaluation. Partitioning
uses stable group keys and `SHA256_GROUP_MODULO` version 1: SHA-256 of UTF-8
`seed + NUL + sorted group keys joined by U+001F`, interpreted from its first
eight bytes modulo 100, assigns buckets 0–79 to train, 80–89 to evaluation, and
90–99 to holdout. The validator recomputes the assignment and rejects a group
observed in multiple splits. External sealed-trace artifacts use
`trajectory://<relative-path>` references, resolved against
`MULTI_AGENT_TRAJECTORY_DIR` (default `~/.pi/agent/trajectories`), so sidecars do
not persist private absolute paths.

The retained RL directories are intentionally empty. Infrastructure readiness
means a future independently evidenced sidecar can be validated; it does not
mean that an RL episode, reward, preference, or evaluation case currently
exists.

## Episode schemas and validation

The authoritative schemas are installed with the bdd-java agent pack at:

- `~/.pi/agent/skills/multi-agent/schemas/bdd-java-episode-v2.schema.json`
- `~/.pi/agent/skills/multi-agent/schemas/bdd-java-rl-episode-v1.schema.json`

The project does not own or maintain divergent schema copies. Set
`BDD_JAVA_EPISODE_SCHEMA` or `BDD_JAVA_RL_EPISODE_SCHEMA` when the authoritative
agent pack is installed elsewhere.

Validate the retained dataset infrastructure and agent contracts from the
repository root:

```bash
./scripts/validate-dataset
./scripts/validate-rl-dataset
./scripts/validate-agent-contracts
```
