# Resume capsule — episode 0004

- Current commit: `e033166222a324620e6ecfb2026db0e0b6bb0d67`
- Current tree: `2dd4ee31ec87695e9eb96e4619f39d06a46f29a6`
- Decision: ADR 0001 closed, case-sensitive CertificateProfile v1 enum vocabularies
- Requirement traceability: `REQ-X509-PROFILE-INTEGRITY-001`, `REQ-X509-PROFILE-INTEGRITY-011`
- Owning agent: `spec-driven`
- Current behavior: `PublicKeyAlgorithm` contains exactly `EC_P256` and `RSA_3072`; declaration order is not semantic.
- Production SHA-256: `0fc94ff23a3d298ff2ecb187c89935650d0fd7e30d39d46aa8d14a3e31dc3dfb`
- Specification SHA-256: `f1a7aa1afe6a2d66883c36641ad2e6d8d76e42e6a3c648da350b5bc0c2896138`
- Last verified result: selected 1/1, full JavaSpec 4/4, zero pending/stubs, exact Java 21 enum shape, Java 21 Maven verify, and dependency checks passed; behavior replay passed.
- Last failure: meaningful RED expectation failure on the generated empty enum — expected the two-token vocabulary but got an empty set.
- Sealed JavaSpec fingerprint: launcher `1.0.0-RC1`; selected JAR SHA-256 `0a6affa008f5452f851b711755237075b1ce1172a1b056d459f7201d5a16128a`.
- Replay note: the launcher path later contained JAR SHA-256 `293ac11e9fe3d1960ab8bfd0faf7e919c82aaa7a3240771ca695f90349a9573f`; replay is not bit-identical to sealed execution.
- Allowed implementation files: the `PublicKeyAlgorithm.java` and `PublicKeyAlgorithmSpec.java` paths; ignored generated/build output may be regenerated.
- Unresolved work: YAML admission, rejection of unknown/miscased input tokens, set parsing/duplicates/order normalization, profile aggregate, JCS/hashing, manifests/audit, lifecycle, and issuance policy remain outside this slice; final SFT promotion requires independent approval.
- Next permitted action: parent may review and commit dataset artifacts. Do not repeat `javaspec describe` for `PublicKeyAlgorithm`; any next domain behavior requires a separately authorized continuation slice.
