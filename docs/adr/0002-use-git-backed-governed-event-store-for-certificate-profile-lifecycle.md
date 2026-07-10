# ADR 0002 — Use a Git-backed governed event store for certificate profile registry lifecycle

## Status

Accepted as an architectural direction.

Implementation status: not implemented. No Git event-store adapter, event streams, CQRS projectors, or read models exist yet.

## Context

Certificate profile registry and lifecycle changes are security-relevant. They need reviewability, historical traceability, tamper evidence, rollback evidence, and a path toward reproducible publication of immutable profile artifacts and manifests.

The user wants to evaluate and proceed with Git as a non-conventional event store because Git's Merkle DAG provides Bitcoin-like hash-linked tamper-evidence properties: commits reference prior commits and trees by cryptographic hash, making unauthorized history rewriting detectable when refs, signatures, and repository governance are protected.

At the same time, Git is not a conventional database or event-store product. It is not optimized for high-volume transactional workloads, complex querying, consensus, runtime issuance state, or low-latency online reads. The architecture therefore needs strict boundaries so the Git-backed design remains replaceable by PostgreSQL, a dedicated event store, OpenSearch, or cache-backed projections later.

## Decision

Use Git as a governed, low-throughput event store/source for certificate profile registry and lifecycle history, and for immutable profile artifact / manifest publication.

Do not use Git as a general runtime database.

Use CQRS to separate the governed write/source side from the read side:

* the write/source side records structured certificate-profile lifecycle events and published immutable artifacts/manifests in governed Git history;
* the initial read side may use simple Git-derived reads or caches;
* later read models may be projected into PostgreSQL, OpenSearch, key-value caches, or other query-optimized stores if query complexity, latency, or operational scale grows.

Keep the Event Sourcing path open by recording profile lifecycle changes as structured event envelopes and by designing projections to be replayable from the Git-backed source.

The Git adapter belongs to the infrastructure layer behind application/domain ports. Application use cases must depend on ports, not on Git APIs, repository layouts, or JGit/CLI details. A later standard database or event-store adapter must be able to replace the Git-backed adapter without changing domain behavior.

This decision complements ADR 0001: certificate profile content remains immutable and content-addressed, while Git provides a governed lifecycle/event history and publication channel around those immutable profile artifacts and manifests.

## Guardrails

The Git-backed event store is allowed only under these guardrails:

* No secrets in Git: private keys, HSM credentials, tokens, passwords, activation secrets, and sensitive operational secrets must never be stored in Git event streams, profile artifacts, manifests, or repository metadata.
* Protected refs are required for event streams and publication refs. Force-push and history rewrites are forbidden for governed streams.
* Published or activatable profile states require signed commits and/or signed tags according to the environment trust model.
* Writes use expected-head / compare-and-swap semantics so concurrent updates fail safely when the observed stream head differs from the expected stream head.
* Each aggregate stream uses one ref/path, or an equivalent explicit ordering rule, so aggregate event ordering is deterministic and replayable.
* Uncontrolled merges are forbidden in event streams. Merge commits are allowed only when an explicit stream ordering and replay rule exists and has been validated.
* Lifecycle events use a structured event envelope with these fields:
  * `eventId`;
  * `aggregateId`;
  * `aggregateVersion`;
  * `eventType`;
  * `occurredAt`;
  * `actor`;
  * `causationId`;
  * `correlationId`;
  * `schemaVersion`;
  * `payload`.
* CQRS projectors are idempotent and replayable. Rebuilding projections from Git history must produce the same logical read model for the same stream state.
* The Git adapter remains in infrastructure behind ports and is replaceable by a standard database or event-store adapter.
* Git is not the runtime certificate issuance database, not a high-volume event store, not a consensus ledger, and not a query engine.

## Consequences

Positive consequences:

* Certificate profile lifecycle history gains strong operational reviewability and hash-linked tamper evidence when Git refs and signatures are governed correctly.
* Profile artifacts, manifests, and lifecycle events can be reviewed, signed, archived, and reproduced using mature Git tooling.
* CQRS keeps read models replaceable and allows the first implementation to remain simple while preserving a path to PostgreSQL, OpenSearch, caches, or a dedicated event store.
* Event envelopes and replayable projectors preserve an Event Sourcing migration path without forcing a dedicated event-store product in the first implementation.
* Infrastructure-only Git integration protects the domain and application layers from a premature persistence-technology lock-in.

Negative consequences and trade-offs:

* Git operations, branch/ref policy, signatures, hooks, backup, and repository access control become security-relevant operational controls.
* Additional design work is required for stream layout, expected-head handling, event schema evolution, replay, projection rebuilding, and publication semantics.
* Git does not provide database-like indexing, query planning, transactions across arbitrary aggregates, global ordering, or online low-latency runtime query guarantees.
* If protected refs, signatures, or repository governance are weak, Git's hash-linked history alone is insufficient to prevent or detect all relevant attacks.
* The design is intentionally non-conventional and may need more documentation and operator training than a standard database-backed registry.

## Anti-fake / Implementation Status

This ADR records an architectural direction and design decision only.

Current implementation support is absent:

* no Git-backed event-store adapter exists;
* no Git stream/ref/path layout is implemented;
* no certificate-profile lifecycle event envelope is implemented;
* no expected-head / CAS write path is implemented;
* no signed commit/tag publication workflow is implemented;
* no CQRS projectors or read models exist;
* no PostgreSQL/OpenSearch/cache projection exists;
* no replay validation exists.

Do not claim runtime support for Git-backed profile lifecycle, Event Sourcing, or CQRS read models until executable requirements, implementation, and validation evidence exist.

## Open Follow-up Decisions

* Define the first Git stream layout: refs, paths, aggregate identifiers, and publication refs/tags.
* Define the exact certificate-profile lifecycle event types and payload schemas.
* Decide the environment-specific signing model for commits, tags, and manifest publication, including key custody for signing keys.
* Define server-side controls: protected refs, hooks, no-force-push enforcement, merge restrictions, retention, backup, and disaster recovery.
* Define the first CQRS read model and rebuild/replay verification strategy.
* Define when query complexity or operational scale requires PostgreSQL, OpenSearch, cache projections, or a dedicated event store.
* Define how Git-backed lifecycle events relate to the broader audit immutability and compliance evidence model.
