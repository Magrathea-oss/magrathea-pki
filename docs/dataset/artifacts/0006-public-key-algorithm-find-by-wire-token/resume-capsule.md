# Resume capsule — episode 0006

- Current commit/tree: `f39c7c0edcd683aea32f9aa8fb7cb568d32b1b15` / `2ae992bebd6a9dc012f2eace6c2823426713769c`
- Requirement: ADR 0003; partial observation under `REQ-X509-SUBJECT-PUBLIC-KEY-PROFILE-002`
- Behavior: exact explicit wire-token lookup is case-sensitive; `EC_P256` matches and `ec_p256` does not.
- Owner: `spec-driven`
- Verified: selected 1/1, subject 3/3, full 6/6, classpath dry-run 3/3, zero pending/stubs, OpenJDK 21 Maven 6/6.
- Last correction: first dry-run omitted compiled classpath and skipped examples; corrected run passed.
- Unresolved: YAML parsing, remaining Scenario Outline rows, null/whitespace/tab/other near-matches, serialization, and policy are separate slices.
- Allowed source files for this completed slice: `PublicKeyAlgorithm.java`, `PublicKeyAlgorithmSpec.java`.
- JavaSpec: RC1, JAR SHA-256 `293ac11e9fe3d1960ab8bfd0faf7e919c82aaa7a3240771ca695f90349a9573f`.
- Next action: parent may review and commit dataset-only artifacts; any further domain behavior requires a separate continuation slice without `describe`.
