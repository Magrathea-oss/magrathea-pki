# Episode 0004 evidence summary

## Behavior

`PublicKeyAlgorithm` defines exactly the case-sensitive CertificateProfile v1 vocabulary `EC_P256` and `RSA_3072`. The JavaSpec compares token names as sets, so enum declaration order is not assigned domain semantics. ADR 0001 authorizes the vocabulary; `REQ-X509-PROFILE-INTEGRITY-001` and `011` are traceability anchors, without claiming YAML admission or either complete Gherkin scenario is implemented.

## Provenance and chronology

- Sealed `RAW_EVENT_STREAM`: 302 events, 59 complete tool-call pairs, valid file SHA-256 values and hash chain.
- Effective agent/prompt: `spec-driven` / `bdd-java-spec-driven-v8`.
- Pre-baseline JavaSpec fingerprint: launcher `1.0.0-RC1`, exact selected JAR SHA-256 `0a6affa008f5452f851b711755237075b1ce1172a1b056d459f7201d5a16128a`.
- Both subject paths were absent at base commit `87af2115...`.
- `javaspec describe` created the initial specification/support and explicitly did not create production.
- One specification edit replaced the generated initialization example with the exact set-vocabulary example.
- Structural RED proposed the missing enum without writing it.
- `javaspec run --generate` first created the production path and reported the exact generated enum skeleton path.
- Executable RED on the generated empty enum failed with expected two-token set versus actual empty set.
- One bounded GREEN edit added only the two enum constants.

## Verification

- Selected JavaSpec: 1/1 passed, zero pending.
- Full domain JavaSpec: 4/4 passed, zero pending.
- Classpath-correct dry-run: 1/1 passed with no pending generation/update work; stub scan was clean.
- Java 21 Maven verify: four tests and JavaSpec 4/4 passed; build success.
- Java 21 bytecode shape: class version 65, enum, exactly two declared constants, only standard compiler-generated enum API.
- Runtime dependency tree with the pre-existing dev profile disabled: zero intrinsic domain runtime dependencies.
- Commit `e033166...` has tree `2dd4ee31...`, parent `87af211...`, and exactly the two authorized source additions. The independently materialized patch and source hashes match the sealed final bytes and commit.
- Independent replay reproduced subject 1/1, full 4/4, Java 21 Maven verify, dependency tree, and public shape. The selected launcher path now contains SHA-256 `293ac11e...`, so replay is behavioral rather than bit-identical; sealed executable provenance remains exact.

## Curation

The episode is a `CURATED_SFT_CANDIDATE`, not final `CURATED_SFT`. Independent final approval has not occurred.
