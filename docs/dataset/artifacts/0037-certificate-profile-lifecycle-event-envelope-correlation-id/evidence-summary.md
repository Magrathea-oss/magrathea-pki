# Episode 0037 independent evidence

- Status: **ACCEPTED_RAW**
- Capture: `RAW_EVENT_STREAM`
- Curation: `CURATED_SFT_CANDIDATE`
- Trace: `1d500fa6-0db9-4607-bb7e-015cb0a377f6`
- Events SHA-256: `59ae3161c917816ee9400bf4fda061d648ea7c18faee7f42d84ceab11771777c`
- Initial state: clean `6c56b961ab9cf7add8ffea7f524bca05452a644a`, tree `3681c871d307a8365d618b86536e0b12428e7794`.
- Final tracked worktree tree: `c94cd8f662704700e7f04a0f80c3abacb0ab1b3a`.
- JavaSpec: launcher `1.0.0-RC1`, source `cd7ff8d1379aabdfcfadc964b3a6473f38383c66`, selected JAR SHA-256 `8522dc72ab0ca87a508436419c4ed430e0ad470375445c689fa871218a8ab501`.
- RED: no-write structural dry run before production mutation.
- Generated candidate: `String arg7` plus one pending `correlationId()` null stub.
- GREEN: component named `correlationId`; redundant stub removed; implicit record accessor used.
- Verification: selected 1/1, envelope 8/8, full 37/37, zero stubs, one ordered eight-argument constructor, one String accessor, Java 21 Maven 37 tests, no unsupported-class warning.
- Scope: exact two-file patch only.
- Privacy: training view excludes machine-local paths and secrets.

Two incorrect relative-path fingerprint attempts and two guessed missing-file reads occurred before behavior edits and did not mutate the repository. The successful fingerprint preceded baseline and edits. Final `CURATED_SFT` still requires independent approval.
