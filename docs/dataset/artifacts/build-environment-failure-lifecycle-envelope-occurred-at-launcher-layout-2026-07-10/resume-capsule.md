# Resume capsule — occurredAt launcher-layout failure

- **Termination:** `BUILD_ENVIRONMENT_FAILURE`
- **Suspected owner:** `TOOLING`
- **Owning implementation agent:** `spec-driven`
- **Dataset status:** `INCIDENT_ONLY`; no numbered episode 0035
- **Curation:** `QUALITY_REJECTED`; not SFT-eligible
- **Requirement/scenario IDs:** `req-x509-profile-lifecycle-001`, ADR 0002
- **Current behavior:** `CertificateProfileLifecycleEventEnvelope` still lacks the supplied lifecycle occurrence timestamp as an `Instant occurredAt` record component/accessor.

## Sealed trace state

- Commit: `638a4d7c4db3b6c1cbf1457a2b2fbc3e62f5ecd2`
- Tree: `45cf472b6b6f530de98476900afb890d2cce18a0`
- Final status: clean
- Production file SHA-256: `f3863042d355dda188eab605e36ec0a74d67493d2b7e9497c491c3311cb760cc`
- Specification file SHA-256: `63269a18fd6dcc4cb50e2ca3d344c9fd9d245910acdebb141e9c65dbe51a1ad7`
- Sealed wrapper SHA-256: `21cefb68809e918c155fdc05779d72730830d941d37472e998712913820a35bf`
- No production, specification, Gherkin, ADR, POM, generated-support, or dataset file changed in the implementation trace.

## Last verified result and stop

The implementation agent verified raw capture variables, upstream launcher commit `33fb70ab0b2758e09af0692fbd193def4f1614be`, discovery fix `5b65099ade375311b5c00873c557e268196ffce2`, and installed `1.0.0-RC1` JAR SHA-256 `2bffe7667dcc217c5a8c8e82815a7ccaa3d97fa53d3b0c847e64361f22bd0ad2`. The JAR contains `formalParameterCount`.

The preflight `cd trust-engine-domain && ../bin/javaspec --launcher-version` exited 2 because the project wrapper mounted only the upstream launcher at `/usr/local/bin/javaspec`. Launcher `33fb70a` derived `/usr/local` as its repository root and could not read `/usr/local/pom.xml`. Baseline, RED, edits, GREEN, and behavior verification were not started.

## Current repaired repository state

- Commit: `bf1b5484ef04b2576898d207a672dd16954d5550`
- Tree before dataset artifacts: `7d79fe6b56034e403f8917158c8922adc0d1daa6`
- Wrapper SHA-256: `ba35f1df489dc8e20dfcee9986958843bd6a537548d75ff3e2e8037356957963`
- Repair: `fix(build): mount javaspec launcher layout`

Dataset-writer did not alter or rerun the repaired wrapper.

## Allowed files for a future implementation replay

- `trust-engine-domain/src/main/java/com/magrathea/trustengine/x509/profile/CertificateProfileLifecycleEventEnvelope.java`
- `trust-engine-domain/src/test/java/spec/com/magrathea/trustengine/x509/profile/CertificateProfileLifecycleEventEnvelopeSpec.java`

## Unresolved work and next permitted action

Start a **new sealed `spec-driven` trace** from the repaired clean repository. Reverify launcher version and selected binary, establish a GREEN baseline, add exactly one meaningful occurredAt example, require assertion RED rather than BROKEN, apply the smallest coherent GREEN, and run all required selected/full/domain verification.

Do not create episode 0035 from this stopped trace and do not revert the repaired wrapper to reproduce the historical failure.
