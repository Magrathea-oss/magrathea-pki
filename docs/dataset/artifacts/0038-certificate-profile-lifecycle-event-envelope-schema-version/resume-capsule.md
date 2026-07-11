# Resume capsule — episode 0038

- Current commit: `b8ed6781c50484812ecd4d5dd2d1270dd62b0589`
- Current tracked worktree tree: `e72732a3c72e05bfa74d6b05c60f5b147890bc1f`
- Requirement: `req-x509-profile-lifecycle-001`; ADR 0002
- Behavior: expose the supplied event schema identifier through ninth `String schemaVersion` record component after `correlationId`.
- Owning implementation agent: `spec-driven`
- Production SHA-256: `3354e1b07185b9cbc7918ecfc9fd30f97d4b4350855ca86bab6932e127a95e91`
- Specification SHA-256: `80e43f2c39cd0de961553ac781e5feee3666026f59fca244d8dfa25546bf388b`
- Last verified: selected 1/1; envelope 9/9; full 38/38; zero stubs; exact shape; Java 21 Maven 38 tests; no unsupported warning; validators pass.
- Last RED: no-write dry run reported pending support/method/constructor generation.
- JavaSpec: launcher `1.0.0-RC1`; correlated source `cd7ff8d1379aabdfcfadc964b3a6473f38383c66`; JAR SHA-256 `8522dc72ab0ca87a508436419c4ed430e0ad470375445c689fa871218a8ab501`; required fixes present.
- Allowed implementation files: envelope record and its JavaSpec only. Dataset-writer owns `docs/dataset/**`.
- Unresolved: implementation and dataset files remain uncommitted; final SFT approval remains pending.
- Next permitted action: parent/human reviews and may commit; do not rewrite the sealed trace, weaken the specification, or add unrelated behavior.
