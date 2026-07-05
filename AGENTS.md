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

## spec-driven Domain/Application Implementation

- `spec-driven` implements one Java behavior slice at a time using **javaspec** red-green-refactor discipline:
  1. one behavior;
  2. one javaspec RED example;
  3. meaningful failing verification;
  4. smallest GREEN production change;
  5. optional behavior-preserving refactor;
  6. verification after each phase;
  7. stop after the slice.

## story-driven Adapter Validation

- `story-driven` implements Cucumber runners, glue, and adapter-side validation.
- Adapters are validated through Gherkin scenarios, not through javaspec.

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

| Layer | Owner |
|---|---|
| `*-domain`, `*-application`, `*-repository-application` behavior | `spec-driven` |
| `*-adapter`, handlers, routers, controllers, Cucumber runners, step definitions | `story-driven` |
| Maven scaffolding, parent POMs, module POMs, Dockerfile, `.dockerignore` | `bdd-java-scaffolder` |
| Frontend code | Frontend agents (only when Gherkin requires it) |

## Generated Artifact Language

All generated project artifacts, source-code comments, documentation, ADRs, reports, C4 descriptions, and user-facing text are written in **English**.
