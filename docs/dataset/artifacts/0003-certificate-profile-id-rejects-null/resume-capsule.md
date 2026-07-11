# Resume capsule — episode 0003

- Current commit: `66fc2ed40a909a5ade8354774abb5c83f6751530`
- Current tree: `d3942d098bcbfa0aebb62fd03f5b01fe21568beb`
- Decision: ADR 0001, CertificateProfile v1 whole-string ID grammar
- Related requirement: `REQ-X509-PROFILE-INTEGRITY-014` (its examples do not explicitly enumerate null)
- Owning agent: `spec-driven`
- Current behavior: explicit null is rejected as outside the complete profile-ID grammar.
- Production SHA-256: `2885f3c13762278cd9c1d928624d14b73561453e5700cf2d60550bf8340f1647`
- Specification SHA-256: `7085be9400a043d2da2a0166779ee70d2fa7e1f242f9f9aeeca8343aab9e9033`
- Last verified result: selected 1/1, subject/full JavaSpec 3/3, zero pending/stubs, and Java 21 Maven success; behavior replay passed.
- Last failure: meaningful RED expectation failure — expected `IllegalArgumentException`, but nothing was thrown.
- Sealed JavaSpec fingerprint: launcher `1.0.0-RC1`; selected JAR SHA-256 `8522dc72ab0ca87a508436419c4ed430e0ad470375445c689fa871218a8ab501`.
- Replay note: the launcher path later contained JAR SHA-256 `0a6affa008f5452f851b711755237075b1ce1172a1b056d459f7201d5a16128a`; replay is not bit-identical to sealed execution.
- Allowed implementation files: the existing `CertificateProfileId.java` and `CertificateProfileIdSpec.java` domain paths.
- Unresolved work: any further grammar behavior requires a separately authorized slice; final SFT promotion requires independent approval.
- Next permitted action: the parent may review and commit dataset artifacts. Do not repeat `javaspec describe` for this subject.
