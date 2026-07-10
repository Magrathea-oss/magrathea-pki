# Resume capsule — episode 0035

- Current commit: `91b9f02a3b75567879ac54130838056f020a2a81`
- Initial tree: `94abe9ff4258f84eb1fd84b399a5c383b4577f19`
- Final tracked worktree tree: `aaa636703a8112e34a115a200f6df0c57028db23`
- Requirement: `req-x509-profile-lifecycle-001`; ADR 0002
- Behavior: `CertificateProfileLifecycleEventEnvelope` exposes the supplied `Instant occurredAt` as its sixth record component and implicit accessor.
- Owning implementation agent: `spec-driven` (`bdd-java-spec-driven-v5`)
- Final production hash: `fe39752ffe8175427727c62b38841c06b7d72dcf57b85cd95a3b942b982f0cf6`
- Final specification hash: `6077665ad56f438a6b3e2570bb08ef0399b86ca99a738442a74b4f3c8e2bca04`
- JavaSpec: launcher `1.0.0-RC1`, source `cd7ff8d1379aabdfcfadc964b3a6473f38383c66`, JAR SHA-256 `8522dc72ab0ca87a508436419c4ed430e0ad470375445c689fa871218a8ab501`.
- Last RED: constructor probe required five arguments but found five plus `Instant`; exit 1.
- Last verified result: selected 1/1, envelope 6/6, full JavaSpec 35/35, Maven 35 tests with no failures/errors/skips, zero stubs; both repository validators pass.
- Caveats: an exploratory launcher run unexpectedly applied the constructor update, then failed on stale generated support; production was restored exactly before the canonical structural probe and explicit safe generation. A post-validation host Maven rerun exited 0 but JaCoCo 0.8.12 emitted `Unsupported class file major version 69` warnings while instrumenting JDK compiler classes; coverage observability is limited and no coverage claim is made, while the selected/full JavaSpec evidence remains valid.
- Unresolved work: independent human approval is required before promotion from `CURATED_SFT_CANDIDATE` to `CURATED_SFT`; implementation and dataset changes remain uncommitted. Upgrade coverage tooling before relying on coverage measurements under this host JDK.
- Allowed implementation files: the lifecycle envelope production record and JavaSpec only. Dataset-writer may modify only dataset-owned paths.
- Next action: parent/human reviews and commits the verified implementation and dataset; do not rewrite the sealed trace or weaken the specification.
