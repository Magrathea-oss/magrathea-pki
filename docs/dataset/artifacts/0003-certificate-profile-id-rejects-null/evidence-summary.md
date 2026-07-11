# Episode 0003 evidence summary

## Behavior

`CertificateProfileId` rejects explicit null because ADR 0001 requires every public construction path to enforce the complete v1 profile-ID grammar, and null cannot match that grammar. `REQ-X509-PROFILE-INTEGRITY-014` is related, but its malformed-string examples do not explicitly enumerate null.

## Provenance and chronology

- Sealed `RAW_EVENT_STREAM`: 308 events, 50 complete tool-call pairs, valid SHA-256 hash chain.
- Effective agent/prompt: `spec-driven` / `bdd-java-spec-driven-v8`.
- Pre-baseline JavaSpec fingerprint: launcher `1.0.0-RC1`, selected JAR SHA-256 `8522dc72ab0ca87a508436419c4ed430e0ad470375445c689fa871218a8ab501`.
- The subject and specification existed at the base commit; no `javaspec describe` action was repeated.
- Green 2/2 continuation baseline preceded one specification edit.
- Selected RED preceded the production edit and failed because no `IllegalArgumentException` was thrown.
- One production edit changed only the compact-constructor condition and preserved the existing error type and message.

## Verification

- Selected null behavior: 1/1 passed, zero pending.
- Subject and full JavaSpec: 3/3 passed, preserving canonical-value and leading-whitespace behaviors.
- Sealed dry-runs found no pending generation/update work; generated support and source scans found zero pending stubs.
- Java 21 Maven test: three tests passed; build success.
- Independent replay at the implementation commit reproduced JavaSpec 3/3, classpath-correct dry-run 3/3 with no pending work, and Java 21 Maven success.
- Replay used a later JAR at the same launcher path (SHA-256 `0a6affa0...`), so it is behavior replay rather than bit-identical executable replay; the sealed execution itself has exact pre-baseline binary provenance.
- Commit `66fc2ed40a909a5ade8354774abb5c83f6751530` has tree `d3942d098bcbfa0aebb62fd03f5b01fe21568beb` and changes exactly the two authorized source files. Its patch is byte-identical to the sealed patch.

## Curation

The episode is a `CURATED_SFT_CANDIDATE`, not final `CURATED_SFT`. Independent final approval has not occurred.
