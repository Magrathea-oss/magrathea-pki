# Resume capsule — episode 0002

- Current commit: `8cbd11e207765263c626bb4fbbea3e5f63e8defc`
- Current tree: `4585c3550145f62d61c559088abcbe157bf5fb5b`
- Requirement: `REQ-X509-PROFILE-INTEGRITY-014`
- Decision: ADR 0001, CertificateProfile v1 whole-string ID grammar
- Owning agent: `spec-driven`
- Current behavior: a non-null profile ID with leading whitespace is rejected without trimming.
- Production SHA-256: `f2d13fa865dc04409f48ba47f488fe775518a3604a88c020907700c4f1607e12`
- Specification SHA-256: `c9fd8f2f0e1c145c2fd180dfea1f2507ed09efd2ad93d7b3dcb14b597f6908e5`
- Last verified result: selected 1/1, existing valid behavior 1/1, full JavaSpec 2/2, zero pending, Java 21 Maven verify success.
- Last failure: meaningful RED expectation failure — expected `IllegalArgumentException`, but nothing was thrown.
- JavaSpec fingerprint: launcher `1.0.0-RC1`; selected JAR SHA-256 `8522dc72ab0ca87a508436419c4ed430e0ad470375445c689fa871218a8ab501`.
- Allowed implementation files: `CertificateProfileId.java` and `CertificateProfileIdSpec.java` in their existing domain source/spec paths.
- Unresolved work: other malformed grammar classes and null handling require separately authorized behavior slices; final SFT promotion requires independent approval.
- Next permitted action: the parent may review and commit dataset artifacts, then delegate at most one separately authorized JavaSpec continuation slice. Do not repeat `javaspec describe` for this subject.
