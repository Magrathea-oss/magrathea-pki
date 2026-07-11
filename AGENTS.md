# AGENTS.md — Repository Policy

This repository follows **BDD-first Java development** using the `bdd-java` workflow.

## Requirement-First Development

- The executable plan is **Gherkin** (`.feature` files).
- No `PLAN.md` is maintained as a planning artifact.
- At least one meaningful RED test must exist before production code changes.
- A requirement is complete only when production behavior exists and semantic validation passes.

## Gherkin as Executable Plan

- Feature files are the single source of truth for requirements.
- Multiple validation modes (unit, integration, e2e) reuse the same feature file.
- Different validation modes differ only through step definitions, glue, runner configuration, tags, profiles, or validation adapters.

## Multi-Runner Rule

- Do not duplicate feature text for different runners.
- Feature files define scenarios; runners define how they are validated.

## Thin Adapter Rule

Adapters follow:

```text
extract → delegate → response
```

Adapters must not contain:
- Domain rules
- Application orchestration
- Persistence logic
- Checksum/ETag computation
- In-memory production state
- Bucket/object existence rules
- Multipart state machines
- Cross-bounded-context translation outside explicit ACL/adapter modules

## spec-driven Domain Implementation

- `spec-driven` implements pure domain behavior one Java behavior slice at a time using **javaspec** red-green-refactor discipline:
  1. admit one externally meaningful behavior;
  2. establish a green baseline;
  3. add one javaspec RED example;
  4. classify the meaningful failure or typed stop;
  5. apply the smallest coherent GREEN domain change;
  6. optionally refactor without changing behavior;
  7. verify selected behavior, full specification, and domain module;
  8. hand off structured evidence to `dataset-writer`.
- A slice means semantic atomicity, not method-count atomicity. One behavior may require a constructor, factory, record component, invariant, typed error, private helper, or multiple mechanically generated members when they are necessary for the same domain behavior.
- A slice is invalid when it batches independent behaviors, weakens a specification, leaves pending generated stubs while claiming GREEN, or works around a javaspec framework incoherence as production design.
- Domain examples must trace to a Gherkin requirement, ADR, or approved domain-design decision. Do not invent javaspec examples solely to create dataset rows.

## story-driven Use Case and Adapter Validation

- `story-driven` implements exactly one coherent Gherkin scenario or application behavior per slice.
- `story-driven` owns application use cases, Cucumber runners, glue, inbound adapters, outbound infrastructure adapters, and adapter-side validation.
- Use cases and adapters are validated through Gherkin scenarios, not through javaspec.
- If a scenario exposes missing pure domain behavior, `story-driven` must stop with `MISSING_DOMAIN_BEHAVIOR` and hand off to `spec-driven`; it must not implement domain rules in application, glue, or adapters.
- Use-case Javadocs should include lightweight traceability to the use-case ID, feature file, and ARC42 requirements appendix section.

## Anti-Fake Completion Rule

Do not create fake functionality or overclaim support.

Use explicit status tags:

- `@implemented-and-validated`
- `@implemented-not-e2e-validated`
- `@partial`
- `@config-only`
- `@placeholder`
- `@absent`
- `@not-implemented`

## Documentation Gap Reporting

Missing documentation is reported with statuses:

- `actionable`
- `blocked`
- `missing-agent-capability`
- `out-of-scope`
- `stale`
- `unknown`

## Technical Baseline

- Java 21 is the default language level.
- Spring Boot 4.1.x is the runtime/application baseline.
- Immutable domain value objects should normally use Java records unless a specific domain or tooling constraint requires a class.

## Bounded Contexts

This project follows a domain-centric layered architecture:

```
trust-engine-domain
trust-engine-application
trust-engine-infrastructure
trust-engine-api-adapter
trust-engine-admin-adapter
trust-engine-cli-adapter
trust-engine-test-support
```

Sub-domains (within the trust-engine umbrella):

```
trust-engine-x509
trust-engine-cvc
trust-engine-ssh
trust-engine-kms
trust-engine-hsm
trust-engine-tpm
```

## Ownership by Layer

| Layer / Artifact | Owner |
|---|---|
| `*-domain` pure domain behavior, invariants, value objects, aggregates, domain services | `spec-driven` |
| `*-application` use cases and application orchestration | `story-driven` |
| `*-infrastructure` outbound adapters, persistence adapters, crypto/provider integrations | `story-driven` |
| `*-adapter`, handlers, routers, controllers, Cucumber runners, step definitions | `story-driven` |
| `docs/dataset/**`, dataset manifests, validation artifacts, resume capsules | `dataset-writer` |
| Maven scaffolding, parent POMs, module POMs, Dockerfile, `.dockerignore` | `bdd-java-scaffolder` |
| Frontend code | Frontend agents (only when Gherkin requires it) |

## Dataset Ownership

- `dataset-writer` independently records, validates, classifies, and externalizes trajectories from `spec-driven` and `story-driven`.
- Implementation agents do not author, approve, or repair their own raw dataset records.
- Dataset episodes are not automatically positive training data because tests passed. `BEHAVIOR_VERIFIED`, `CURATED_SFT_CANDIDATE`, and `CURATED_SFT` are separate curation states.
- The previous domain-training corpus was explicitly discarded after quality regressions. Dataset numbering restarts at `0001`; only newly captured, sealed, javaspec-guided episodes may enter the replacement corpus.

## Typed Stops and Handoffs

- A correct typed stop is useful output and must be handed to `dataset-writer` with reproducible evidence.
- Common stop outcomes include `FRAMEWORK_INCOHERENCE`, `SPECIFICATION_AMBIGUITY`, `DOMAIN_MODEL_INCONSISTENCY`, `BASELINE_FAILURE`, `BUILD_ENVIRONMENT_FAILURE`, `SECURITY_RISK`, `REGRESSION_DETECTED`, `CONTEXT_LIMIT_REACHED`, and `HUMAN_DECISION_REQUIRED`.
- `spec-driven` and `story-driven` hand success, typed stops, and checkpoints to `dataset-writer` using the active bdd-java handoff contract.
- `dataset-writer` may return a validated correction request or compact resume capsule, but never modifies production, specs, Gherkin, ADRs, POMs, or adapters to make an episode valid.

## Generated Artifact Language

All generated project artifacts, source-code comments, documentation, ADRs, reports, C4 descriptions, and user-facing text are written in **English**.
