# Resume capsule — episode 0037

- Current commit: `6c56b961ab9cf7add8ffea7f524bca05452a644a`
- Current tracked worktree tree: `c94cd8f662704700e7f04a0f80c3abacb0ab1b3a`
- Requirement: `req-x509-profile-lifecycle-001`; ADR 0002
- Behavior: expose the supplied lifecycle correlation identifier through eighth `String correlationId` record component after `causationId`.
- Owning implementation agent: `spec-driven`
- Production SHA-256: `6296a30050709ab0e8bd41b36d02eac5dc2b464415a34a75be9ea3fc6709ad0f`
- Specification SHA-256: `0edb7c8ec2a307b416eeac973823bfa8dc79f2ddfccc0ff56b92d7dcc9273dcd`
- Last verified: selected 1/1; envelope 8/8; full 37/37; zero stubs; exact shape; Java 21 Maven 37 tests; no unsupported warning; validators pass.
- Last RED: no-write dry run reported pending support/method/constructor generation.
- JavaSpec: launcher `1.0.0-RC1`; source `cd7ff8d1379aabdfcfadc964b3a6473f38383c66`; JAR SHA-256 `8522dc72ab0ca87a508436419c4ed430e0ad470375445c689fa871218a8ab501`; required fix present.
- Allowed implementation files: envelope record and its JavaSpec only. Dataset-writer owns `docs/dataset/**`.
- Unresolved: implementation and dataset files remain uncommitted; final SFT approval remains pending.
- Next permitted action: parent/human reviews and may commit; do not rewrite the sealed trace, weaken the specification, or add unrelated behavior.
