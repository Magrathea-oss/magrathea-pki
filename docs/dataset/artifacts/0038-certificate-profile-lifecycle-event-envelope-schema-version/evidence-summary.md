# Episode 0038 independent evidence

- Status: **ACCEPTED_RAW**
- Capture: `RAW_EVENT_STREAM`
- Curation: `CURATED_SFT_CANDIDATE`
- Trace: `ca9d3deb-fbd8-4abb-a66f-00ddfe56aa75`
- Events SHA-256: `04c46df9fb674a2e1afd38aadd984ea6d3f4291a72d2c5c47e7800d8926ea64f`
- Initial state: clean `b8ed6781c50484812ecd4d5dd2d1270dd62b0589`, tree `d839bf2acde4584f4237bc4d8bcc7dceb43d5b83`.
- Final tracked worktree tree: `e72732a3c72e05bfa74d6b05c60f5b147890bc1f`.
- JavaSpec: launcher `1.0.0-RC1`, correlated source `cd7ff8d1379aabdfcfadc964b3a6473f38383c66`, selected JAR SHA-256 `8522dc72ab0ca87a508436419c4ed430e0ad470375445c689fa871218a8ab501`.
- RED: no-write structural dry run before production mutation.
- Generated candidate: `String arg8` plus one pending `schemaVersion()` null stub.
- GREEN: component named `schemaVersion`; redundant stub removed; implicit record accessor used.
- Verification: selected 1/1, envelope 9/9, full 38/38, zero stubs, one ordered nine-argument constructor, one String accessor, Java 21 Maven 38 tests, no unsupported-class warning.
- Scope: exact two-file patch only.
- Privacy: training view excludes machine-local paths and secrets.

Two incorrect relative-path fingerprint attempts occurred before the successful pre-baseline fingerprint and did not mutate the repository. Final `CURATED_SFT` still requires independent approval.
