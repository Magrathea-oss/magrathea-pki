# Resume capsule — episode 0036

- Current commit: `476a0caf517f45948c9658dc46f5b960b14bf48f`
- Current tracked worktree tree: `e24477b4acc515a1021a34f7f623dcac27291761`
- Requirement: `req-x509-profile-lifecycle-001`; ADR 0002
- Behavior: expose the supplied command identifier through seventh `String causationId` record component after `occurredAt`.
- Owning implementation agent: `spec-driven`
- Production SHA-256: `d9d0dbb7bca246bb7bbf76bc3713804c62681e8d4a6df56ddd116422f204b6cd`
- Specification SHA-256: `fe5df244ff07265fd62bbf4b418fc8296381647e1a83ec284c21e53c3f04c1d8`
- Last verified: selected 1/1; envelope 7/7; full 36/36; zero stubs; exact shape; Java 21 Maven 36 tests; no unsupported warning; both validators pass.
- Last RED: no-write dry run reported pending support/method/constructor generation.
- JavaSpec: launcher `1.0.0-RC1`; source `cd7ff8d1379aabdfcfadc964b3a6473f38383c66`; JAR SHA-256 `8522dc72ab0ca87a508436419c4ed430e0ad470375445c689fa871218a8ab501`; required fixes present.
- Allowed implementation files: envelope record and its JavaSpec only. Dataset-writer owns `docs/dataset/**`.
- Unresolved: implementation and dataset files remain uncommitted; final SFT approval remains pending.
- Next permitted action: parent/human reviews and may commit; do not rewrite the sealed trace, weaken the specification, or add unrelated behavior.
