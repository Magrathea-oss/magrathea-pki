# Episode 0034 evidence summary

## Slice

- Behavior: `CertificateProfileLifecycleEventEnvelope` exposes lifecycle `eventId` metadata supplied through record construction.
- Requirement authority supplied in handoff: `features/x509/certificate-profile-lifecycle.feature` `@req-x509-profile-lifecycle-001` and ADR `docs/adr/0002-use-git-backed-governed-event-store-for-certificate-profile-lifecycle.md` structured envelope fields.
- Base commit: `02d843683dc347305a2184630ead8f2b5e19dd01`.
- Base tree: `c6daa250ca78fd79ed2d82d9802a84ff44379f39`.
- Capture mode: reconstructed from implementation-agent handoff plus local repository/report checks; not a raw event stream.

## Changed tracked files before dataset recording

- `trust-engine-domain/src/main/java/com/magrathea/trustengine/x509/profile/CertificateProfileLifecycleEventEnvelope.java`
- `trust-engine-domain/src/test/java/spec/com/magrathea/trustengine/x509/profile/CertificateProfileLifecycleEventEnvelopeSpec.java`

## Hash evidence

| File | Pre-edit SHA-256 | Final SHA-256 |
| --- | --- | --- |
| `features/x509/certificate-profile-lifecycle.feature` | `072d852a5fc3e0aa56bde81290c55d4f2c8db240cb3bb61b982be500a0569157` | unchanged per handoff |
| `docs/adr/0002-use-git-backed-governed-event-store-for-certificate-profile-lifecycle.md` | `43cc9d679ea3e0660f026a78e74dea459c3be15c2622c62fd346f4b4135f6784` | unchanged per handoff |
| `trust-engine-domain/src/main/java/com/magrathea/trustengine/x509/profile/CertificateProfileLifecycleEventEnvelope.java` | `813e99debbddd53faea3c6defcf2792a2fdcfc4a736bd3d9e096e6ba9c736357` | `f3863042d355dda188eab605e36ec0a74d67493d2b7e9497c491c3311cb760cc` |
| `trust-engine-domain/src/test/java/spec/com/magrathea/trustengine/x509/profile/CertificateProfileLifecycleEventEnvelopeSpec.java` | `66ca8f5f04b88228c87bd4ee3a140a6e64e32ff4a5509d20453c30e116a06bd5` | `63269a18fd6dcc4cb50e2ca3d344c9fd9d245910acdebb141e9c65dbe51a1ad7` |
| ignored generated support `CertificateProfileLifecycleEventEnvelopeSpecSupport.java` | `cb018679b67350c7fa0e509160c9a4efbe92b51cc1d2b26e28f35ce77325a1a5` | `bc4f497adef54d4a5934ad354d9c48e12a579be7f5d954201a7d78ca91cdef0e` |

Local final byte sizes checked for changed files: production 199 bytes, spec 1467 bytes, generated support 3198 bytes.

## RED/GREEN evidence

- Baseline selected pre-edit: javaspec class run report `javaspec-baseline-lifecycle-envelope.json` passed 4/4.
- RED: after adding exactly one example `it_exposes_the_lifecycle_event_identifier` and running javaspec generation, the selected command exited 1 with 1 total, 0 passed, 1 failed, 0 broken, 0 pending. Failure message: `Expected equality(evt-x509-profile-2026-0001) but got null`. Handoff reports one generated production stub at RED, removed for GREEN.
- GREEN implementation: production record component changed from generated placeholder/stub `arg4` to canonical component `String eventId`; record accessor supplies behavior.
- Selected GREEN: `javaspec-green-selected-lifecycle-event-id.json` passed 1/1.
- Full javaspec: `javaspec-green-full-domain.json` passed 34/34.
- Domain Maven: `maven-domain-test-summary.json` records exit 0 and surefire aggregate 34 tests, 0 failures, 0 errors, 0 skipped. JaCoCo emitted Java 25 instrumentation warnings but build exit was 0.
- Stub scan: handoff states `grep -R "javaspec:stub" -n trust-engine-domain/src/main/java trust-engine-domain/target/generated-sources/javaspec` produced no output.
- `git diff --check` passed during dataset-writer verification.
- Worktree patch SHA-256: `7f64bc6c548a10682cf0abbfdb99a084df44f3e3ef1df3a3bfa4a68a2d0ef694`.

## Javaspec fingerprint

Handoff supplied: local upstream javaspec repository HEAD `6b102cbc141ca07da4df20b1f53dbfd2ef1a0e87` on `develop`; contains record-prefix fix commit `93188fb`; CLI supports `--class`, `--example`, `--report`, `--dry-run`; `--version` unsupported. The absolute local repository path was intentionally not copied into this artifact.

## Admission note

This episode records factual evidence and passes V2 schema validation, but provenance is reconstructed rather than a raw event stream. The implementation-agent prompt version and exact tool-registry version were not supplied in the handoff, so the episode is not SFT-eligible without independent curation.
