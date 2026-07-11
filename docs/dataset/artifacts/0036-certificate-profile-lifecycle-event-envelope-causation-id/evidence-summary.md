# Episode 0036 independent evidence

- Status: **ACCEPTED_RAW**
- Capture: `RAW_EVENT_STREAM`
- Curation: `CURATED_SFT_CANDIDATE`
- Trace: `442a5120-df31-48fc-940c-74e71cabe8a0`
- Events SHA-256: `09841e29d4d85dc42ed8eb61a1472914da1d7a119b4ac9d7e1d2b235358e85f3`
- Initial state: clean `476a0caf517f45948c9658dc46f5b960b14bf48f`, tree `11855539144ba19b76f3f0a57f92e6993c08df4f`.
- Final tracked worktree tree: `e24477b4acc515a1021a34f7f623dcac27291761`.
- JavaSpec: `1.0.0-RC1`, source `cd7ff8d1379aabdfcfadc964b3a6473f38383c66`, selected JAR SHA-256 `8522dc72ab0ca87a508436419c4ed430e0ad470375445c689fa871218a8ab501`.
- RED: no-write structural dry run before production mutation.
- Generated candidate: `String arg6` plus one pending `causationId()` stub.
- GREEN: component named `causationId`; redundant stub removed; implicit record accessor used.
- Verification: selected 1/1, envelope 7/7, full 36/36, zero stubs, one ordered seven-argument constructor, one String accessor, Java 21 Maven 36 tests, no unsupported-class warning.
- Scope: exact two-file patch only.
- Both repository validators pass in the current worktree.

The transport retry and two blocked exploratory read commands occurred before the behavior edit and did not alter the repository. They remain visible as curation caveats. Final `CURATED_SFT` still requires independent approval.
