# Resume capsule — occurredAt clean replay environment failure

- **Termination:** `BUILD_ENVIRONMENT_FAILURE`
- **Suspected owner:** `TOOLING`
- **Owning implementation agent:** `spec-driven`
- **Dataset status:** `INCIDENT_ONLY`; no numbered episode 0035
- **Requirement/scenario IDs:** `req-x509-profile-lifecycle-001`, ADR 0002
- **Current behavior:** `CertificateProfileLifecycleEventEnvelope` should expose its supplied lifecycle occurrence timestamp through an `Instant occurredAt` record component/accessor.

## Repository state

- Commit: `88682f87bab011bfef4e49a62af963c2f86624b7`
- Tree: `aa0017c1e2c8fc536d6e690d2b6b37ad6b4f65ff`
- Sealed final status: clean
- Production file SHA-256: `f3863042d355dda188eab605e36ec0a74d67493d2b7e9497c491c3311cb760cc`
- Specification file SHA-256: `63269a18fd6dcc4cb50e2ca3d344c9fd9d245910acdebb141e9c65dbe51a1ad7`
- All attempted source and specification changes were reverted.

## Last verified result

The focused baseline passed 5/5 examples with no failed, broken, skipped, or pending examples.

The attempted new example did **not** establish an admissible RED. It was BROKEN with `No matching constructor found`. Generated support put `Instant` first and generated an `Object occurredAt()` production stub. Both the example and stub were reverted. GREEN was not attempted.

## Environment fingerprint and failure

- javaspec source commit: `5b65099ade375311b5c00873c557e268196ffce2`
- Selected `0.1.0-SNAPSHOT` JAR SHA-256: `01d396ca1e04fd5ccc1e6b2660a4e84c78ddee154e201883c9a04fed779c3a37`
- The selected JAR predates the fix and lacks `SpecCallScanner.SpecMethodParams.formalParameterCount`.
- The project launcher prefers that Maven-local snapshot over the source checkout target JAR; at capture time both binaries had the same stale hash.

## Allowed files for a future implementation replay

- `trust-engine-domain/src/main/java/com/magrathea/trustengine/x509/profile/CertificateProfileLifecycleEventEnvelope.java`
- `trust-engine-domain/src/test/java/spec/com/magrathea/trustengine/x509/profile/CertificateProfileLifecycleEventEnvelopeSpec.java`

## Unresolved work and next permitted action

1. Rebuild/install javaspec from commit `5b65099ade375311b5c00873c557e268196ffce2` or later.
2. Verify the **selected binary**, not only the source checkout: `javap` must show `formalParameterCount` on `SpecCallScanner$SpecMethodParams`, and its JAR hash must differ from the stale hash above.
3. Start a new sealed `spec-driven` raw capture from the clean repository state.
4. Re-establish baseline, add exactly one occurredAt example, require a meaningful assertion RED rather than BROKEN, then perform the smallest coherent GREEN and full verification.

Do not resume implementation against the stale JAR and do not create episode 0035 from this stopped trace.
