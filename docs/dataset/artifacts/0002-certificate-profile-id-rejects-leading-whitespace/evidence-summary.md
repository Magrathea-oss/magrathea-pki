# Episode 0002 evidence summary

## Behavior

`CertificateProfileId` rejects a non-null identifier prefixed by leading whitespace because the complete input does not match the normative ADR 0001 v1 grammar. This is one continuation behavior authorized by `REQ-X509-PROFILE-INTEGRITY-014`.

## Provenance and chronology

- Sealed `RAW_EVENT_STREAM`: 284 events, 54 complete tool-call pairs, valid SHA-256 hash chain.
- Effective agent/prompt: `spec-driven` / `bdd-java-spec-driven-v8`.
- Pre-baseline JavaSpec fingerprint: launcher `1.0.0-RC1`, selected JAR SHA-256 `8522dc72ab0ca87a508436419c4ed430e0ad470375445c689fa871218a8ab501`.
- Continuation subject existed at the base commit; no `javaspec describe` action was repeated.
- Green baseline preceded one specification edit.
- Selected RED preceded the production edit and failed because no `IllegalArgumentException` was thrown.
- One bounded production edit added whole-input grammar enforcement.

## Verification

- Selected behavior: 1/1 passed, zero pending.
- Existing valid behavior: 1/1 passed.
- Full JavaSpec: 2/2 passed, zero failed, broken, skipped, or pending.
- Corrected dry-run shape/stub check: 2/2 passed and no pending generation/update work.
- Java 21 Maven verify: two tests passed; JavaSpec plugin 2/2; build success.
- Independent replay at the implementation commit reproduced full JavaSpec 2/2 and Java 21 Maven verify success.
- Commit `8cbd11e207765263c626bb4fbbea3e5f63e8defc` has tree `4585c3550145f62d61c559088abcbe157bf5fb5b` and changes exactly the two authorized source files.

## Curation

The episode is a `CURATED_SFT_CANDIDATE`, not final `CURATED_SFT`. Independent final approval has not occurred.
