# ADR 0003 — Use enriched enums for stable algorithm wire identities

## Status

Accepted as an architectural decision.

Implementation status: planned and not implemented. This ADR does not assert that the taxonomy, enriched enums, rename, policy enforcement, or standards-profile validation exists in production.

## Context

PKI algorithm names are not one interchangeable vocabulary. A subject public-key encoding, a certificate issuer signature, a provider mechanism, a CVC algorithm, an SSH algorithm, and a content hash have different semantics and often different wire identifiers and parameter rules. Combining them into a flat `Algorithm` or `PublicKeyAlgorithm` type would permit invalid combinations and obscure protocol boundaries.

The current [`PublicKeyAlgorithm`](../../trust-engine-domain/src/main/java/com/magrathea/trustengine/x509/profile/PublicKeyAlgorithm.java) is a bare Java enum containing `EC_P256` and `RSA_3072`. Its current [JavaSpec specification](../../trust-engine-domain/src/test/java/spec/com/magrathea/trustengine/x509/profile/PublicKeyAlgorithmSpec.java) derives the vocabulary from `Enum.name()`. In CertificateProfile v1, those two case-sensitive strings are normative wire tokens under [ADR 0001](0001-use-content-addressed-yaml-for-certificate-profiles.md) and the [profile-integrity requirements](../../features/x509/certificate-profile-integrity.feature).

Primary-source profiles materially diverge. The following examples are scoped to the cited editions, reviewed on 2026-07-11, and must not be generalized into one timeless allow-list:

* [ETSI TS 119 312 V1.5.1 (2024-12)](https://www.etsi.org/deliver/etsi_ts/119300_119399/119312/01.05.01_60/ts_119312v010501p.pdf) defines trust-service cryptographic suites, recommendations, and transition periods, including choices that do not match the WebPKI set.
* [CA/B Forum TLS Baseline Requirements v2.2.8 (2026-06-16)](https://github.com/cabforum/servercert/tree/refs/tags/BRs/v2.2.8) constrains publicly trusted TLS subject keys and certificate signatures differently from ETSI and other deployment profiles.
* [BSI TR-03116-4, Stand 2025](https://www.bsi.bund.de/SharedDocs/Downloads/DE/BSI/Publikationen/TechnischeRichtlinien/TR03116/BSI-TR-03116-4.pdf) defines German eID-specific algorithm requirements and transitions.
* [FIPS 186-5 (2023-02-03)](https://doi.org/10.6028/NIST.FIPS.186-5) specifies approved digital-signature techniques and parameter constraints, but it does not by itself establish that a product or deployment is operating an approved validated module.

The divergence is operationally significant, not merely terminological. In the cited editions, ETSI recommends RSA-PSS and includes Brainpool and NIST curves while carrying time-bounded legacy choices; the TLS Baseline Requirements constrain subscriber keys to RSA or specified NIST curves and constrain RSA-PSS parameters; BSI's eID profile gives its own X.509 signature choices and transitions; and FIPS 186-5 permits EdDSA and an RSA-PSS salt-length range that an ecosystem profile may narrow. Each statement applies only in the document's stated scope and applicability rules.

These documents have different scopes, revision processes, algorithm sets, parameters, and transition rules. Certification and assurance attach to concrete products, cryptographic modules, evaluated configurations, operational environments, and evidence—not to an enum label. In particular, [NIST CMVP](https://csrc.nist.gov/projects/cryptographic-module-validation-program) validates cryptographic modules, and [Common Criteria Part 1, CC:2022 Revision 1](https://www.commoncriteriaportal.org/files/ccfiles/CC2022PART1R1.pdf) evaluates defined products and configurations against a security target. This ADR does not claim FIPS, eIDAS, ETSI, Common Criteria, or WebPKI certification or conformance.

## Decision

Use Java enriched enums as the primary compiled representation for closed, stable intrinsic algorithm identities. Each enum value must expose an explicit, immutable `wireToken`; it may also expose intrinsic protocol facts that are stable for that identity, such as a normative OID, SSH algorithm name, key family, or fixed parameter identity. The exact wire token is normative and case-sensitive.

Code, YAML, JSON, persistence, events, and audit evidence must serialize and compare the explicit wire token. They must never persist or serialize an enum ordinal or Java enum constant name. This prohibition applies even when a current Java name happens to equal its wire token. Refactoring a Java identifier must not silently change a protocol or stored identity.

Define separate closed taxonomies for at least:

1. X.509 subject SubjectPublicKeyInfo (SPKI) profiles;
2. X.509 issuer signature suites, including their required `AlgorithmIdentifier` and parameter semantics;
3. KMS/provider mechanisms and capabilities;
4. CVC algorithms;
5. SSH key and signature algorithms; and
6. content-hashing algorithms used for content addressing or other non-signature purposes.

A value from one taxonomy is not implicitly admissible in another. Key-agreement-only schemes, post-quantum or hybrid schemes, and future protocol families must enter the taxonomy appropriate to their actual semantics rather than being added to a generic public-key union.

Rename the Java type `PublicKeyAlgorithm` to `SubjectPublicKeyProfile` as planned implementation work because the latter states the X.509 SPKI role more accurately. The rename must preserve the CertificateProfile v1 YAML field name `publicKeyAlgorithms` and the exact wire tokens `EC_P256` and `RSA_3072`. It must not change the normative canonical JSON bytes, golden SHA-256 digest, or profile ID in ADR 0001:

```text
d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee
x509-profile-v1-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee
```

No mutable or deployment-specific assertion belongs in an algorithm enum. In particular, enums must not contain current approval flags, deprecation or transition dates, security horizons, standards editions, deployment permissions, provider/module certification state, or compliance evidence. Those facts vary by policy edition, time, jurisdiction, provider, module, configuration, or evidence snapshot and belong outside intrinsic identities under [ADR 0004](0004-use-governed-content-addressed-yaml-deployment-policy-snapshots.md).

Use records or narrowly scoped sealed parameter types only when an algorithm identifier has structured parameters that cannot be represented safely as fixed intrinsic enum data. A broad sealed hierarchy is not the primary algorithm taxonomy.

All domain implementation slices arising from this ADR must use JavaSpec RED–GREEN–REFACTOR discipline and trace to approved executable requirements or architecture decisions. JavaSpec can express exact enum vocabularies and ordinary enriched-enum behavior, but its observed RC1 generation model cannot coherently generate heterogeneous top-level sealed permittees. Such a mismatch must produce an explicit `FRAMEWORK_INCOHERENCE` typed stop with suspected owner `JAVASPEC`, not a production-design workaround.

Implementation traces and passing tests are not automatically reinforcement-learning evidence. Dataset capture and acceptance remain independently owned and gated. Existing relevant episodes may be raw event streams or curated SFT candidates, but no current data is claimed to be RL-ready. RL readiness requires an independently defined reward contract, state/action evidence, partition controls, hidden verification, and any required preference alternatives.

## Consequences

Stable explicit wire tokens survive Java refactoring and prevent ordinal/name coupling in persisted data.

Protocol-specific types make invalid cross-protocol combinations harder to represent and allow each bounded context to evolve without a misleading universal algorithm hierarchy.

The model requires deliberate mapping between subject profiles, signature suites, KMS/provider mechanisms, and deployment policy. This is additional code, but the mapping becomes explicit and auditable.

Adding a new token changes an admission vocabulary and requires requirements and compatibility governance. It can preserve the canonical bytes and identities of already admitted CertificateProfile v1 documents, but old and new readers may disagree about admission. Any change to CertificateProfile v1 fields, defaults, canonicalization, or identity semantics requires a new identity namespace under ADR 0001.

An enum value establishes only intrinsic identity. It never proves that an algorithm is permitted for a deployment, secure at an evaluation instant, supported by a provider, or covered by certification evidence.

## Alternatives Considered

A single universal algorithm enum was rejected because it collapses subject keys, signatures, mechanisms, protocols, and hashing into an unsafe flat union.

Free-form strings were rejected as the compiled domain model because they defer spelling, parameter, and compatibility failures until runtime and weaken exhaustive handling.

A broad sealed algorithm hierarchy was rejected as the primary model because stable closed identities fit enriched enums and because the current JavaSpec limitation would encourage tooling-driven model distortion. Narrow structured parameter types remain permitted where semantically necessary.

Putting standards approval and transition metadata in enums was rejected because those facts are mutable, profile-scoped, time-scoped, and evidence-dependent.

## Evidence

* [ADR 0001 — Use content-addressed YAML for certificate profiles](0001-use-content-addressed-yaml-for-certificate-profiles.md)
* [CertificateProfile v1 executable requirements](../../features/x509/certificate-profile-integrity.feature)
* [Current `PublicKeyAlgorithm`](../../trust-engine-domain/src/main/java/com/magrathea/trustengine/x509/profile/PublicKeyAlgorithm.java) and [JavaSpec specification](../../trust-engine-domain/src/test/java/spec/com/magrathea/trustengine/x509/profile/PublicKeyAlgorithmSpec.java)

## Related ADRs

* [ADR 0004 — Use governed content-addressed YAML deployment-policy snapshots](0004-use-governed-content-addressed-yaml-deployment-policy-snapshots.md)
