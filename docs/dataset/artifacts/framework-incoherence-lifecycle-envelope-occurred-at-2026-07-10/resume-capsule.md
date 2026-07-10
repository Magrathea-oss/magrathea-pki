# Resume capsule — lifecycle envelope `occurredAt`

- **Trace ID:** `8cc6d007-2563-4783-b5f2-de380b374f3e`
- **Workflow:** `bdd-java`
- **Owning agent at stop:** `spec-driven`
- **Suspected incident owner:** `JAVASPEC`
- **Termination:** `FRAMEWORK_INCOHERENCE`
- **Base/final commit:** `13de845ed8076f849efd3375aedbfdda9e23c9c6`
- **Base tree:** `f7bbc031dae169e5f82404dc5c1ab5b75386609e`
- **Final tree with retained RED spec:** `e3138e109ff7490b31367ac01bc681b0f8709643`
- **Requirement:** `features/x509/certificate-profile-lifecycle.feature` / `@req-x509-profile-lifecycle-001`
- **Architecture authority:** ADR 0002 structured lifecycle envelope metadata
- **Current behavior:** `CertificateProfileLifecycleEventEnvelope` does not expose `occurredAt`; only the RED example is retained.
- **javaspec fingerprint:** `2f2d07452c527d20531760efb4a80cfb60feebdf`

## Relevant hashes

- Production record: `f3863042d355dda188eab605e36ec0a74d67493d2b7e9497c491c3311cb760cc`
- RED specification: `06909191164799e54dc02045e3add9abd994e5fbd6ff9ce0e8f03c53d7c6932d`
- Feature authority: `072d852a5fc3e0aa56bde81290c55d4f2c8db240cb3bb61b982be500a0569157`
- ADR authority: `43cc9d679ea3e0660f026a78e74dea459c3be15c2622c62fd346f4b4135f6784`
- RED report: `63191153dcf12a3ce068c8b45a63edd08a257263a6dd703963c8823abaa34d70`

## Last verified result

Before the RED edit, focused javaspec passed `5/5`, full javaspec passed `34/34`, and domain Maven verification exited `0`.

## Last stop

The selected generated run was BROKEN `1/1`: javaspec generated `Object occurredAt()` and changed support construction to `(Instant, String, String, long, String, Instant)`, causing `No matching constructor found`. The generated production stub was reverted. No GREEN change or post-GREEN verification occurred.

## Unresolved work and next permitted action

JAVASPEC must correct or explicitly classify the record-component/constructor evolution behavior. Only after that decision may `spec-driven` resume from the retained RED example and perform the smallest coherent GREEN plus selected, full, and domain verification.

## Allowed implementation files on resume

- `trust-engine-domain/src/main/java/com/magrathea/trustengine/x509/profile/CertificateProfileLifecycleEventEnvelope.java`
- `trust-engine-domain/src/test/java/spec/com/magrathea/trustengine/x509/profile/CertificateProfileLifecycleEventEnvelopeSpec.java`

Do not create episode `0035` from this stop. This capsule records a framework incident, not verified behavior success.
