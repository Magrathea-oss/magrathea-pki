# Resume capsule — episode 0001

- Commit/tree: `f6f533fadfd7a4c18b5dbde43ae44d9ced808c84` / `84a35e8e9382105a3c56866fa9ad98f10f9323b6`; sealed worktree clean.
- Requirement: `req-x509-profile-integrity-001`; authority: ADR 0001.
- Behavior: `CertificateProfileId` preserves and exposes the supplied canonical identifier through exact `String value` record component.
- Owner: `spec-driven`.
- Production SHA-256: `0d1364e872f896de4cd988e305aac14c1fb8edca29f24230f0dcd67a13e55227`.
- Spec SHA-256: `c5c47750b7dbe23903c70958e57ce7f96b4cbe32a672379f8ca456da2e08b583`.
- Last verified: selected/subject/full 1/1, zero stubs, exact shape, Java 21 Maven one test, zero unsupported warnings.
- Last failure: stale ignored JavaSpec class cache produced `NoSuchMethodError`; ignored target cleanup resolved it without source mutation.
- Unresolved: independent approval before final SFT; invalid-input behavior is a separate future slice.
- Next action: parent reviews and may commit dataset artifacts; do not rewrite the sealed trace or weaken the specification.
