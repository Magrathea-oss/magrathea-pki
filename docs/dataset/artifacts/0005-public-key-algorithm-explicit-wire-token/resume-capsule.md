# Resume capsule — episode 0005

- Current commit/tree: `ddbbd081ad372570730832f6e734527928278dda` / `d037a38b29172086f21ba7373b31b17f78ebe233`
- Requirement: `REQ-X509-SUBJECT-PUBLIC-KEY-PROFILE-001`; ADR 0003
- Behavior: existing `PublicKeyAlgorithm` values expose explicit immutable case-sensitive same-spelling wire tokens.
- Owner: `spec-driven`
- Last verified: selected 1/1, subject 2/2, full 5/5, dry-run 2/2 with zero pending, OpenJDK 21 Maven pass, zero stubs.
- Last process failure: first selected candidate was BROKEN by an incorrect reflection assertion and was corrected specification-only.
- Unresolved: rename to `SubjectPublicKeyProfile`, taxonomy expansion, parsing, policy/compliance behavior, and final independent SFT approval remain separate work.
- Next action: parent may review/commit dataset artifacts; any domain continuation requires a separately authorized JavaSpec slice and must not repeat `describe`.
