# Evidence summary — episode 0006

- **Behavior:** exact `EC_P256` resolves to `Optional.of(EC_P256)`; lowercase `ec_p256` resolves to `Optional.empty()`.
- **Traceability:** ADR 0003 and a partial row/observation under REQ-X509-SUBJECT-PUBLIC-KEY-PROFILE-002. The Scenario Outline is not complete.
- **Chronology:** existing-subject baseline 5/5; one specification edit; meaningful missing-static-member compilation RED; bounded production edit; selected 1/1, subject 3/3, full 6/6. No `describe` was repeated.
- **Shape:** `public static Optional<PublicKeyAlgorithm> findByWireToken(String)`, comparing the explicit `wireToken` field without case folding. Vocabulary and wire tokens remain `EC_P256` and `RSA_3072`.
- **No pending work:** corrected classpath dry-run passed 3/3 with zero pending generation/update work and zero stubs.
- **Runtime:** OpenJDK 21 Maven verification passed six tests. Launcher RC1 JAR SHA-256 remained stable.
- **Scope:** implementation commit `f39c7c0` contains exactly the two authorized Java source files.
- **Honest corrections:** wrong-root fingerprint and help commands exited 127; the first dry-run omitted classpath and skipped examples. None is used as GREEN evidence.
- **Limitations:** no null, whitespace/tab, YAML parsing, serialization, policy, other near-match, hidden-test, preference, alternative, counterfactual, or complete-scenario claim.
