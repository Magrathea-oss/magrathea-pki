# ADR 0004 — Use governed content-addressed YAML deployment-policy snapshots

## Status

Accepted as an architectural decision.

Implementation status: planned and not implemented. No policy schema, canonicalizer, signer, trusted distribution path, validator catalog, admission service, reload mechanism, evaluator, or audit binding is claimed to exist.

## Context

Algorithm eligibility changes with deployment purpose, standards edition, jurisdiction, evaluation time, cryptographic provider, certified module/configuration, and available evidence. Stable algorithm identity therefore cannot carry mutable compliance policy.

Primary-source deployment profiles materially diverge. This decision is based on the following edition-scoped examples reviewed on 2026-07-11:

* [ETSI TS 119 312 V1.5.1 (2024-12)](https://www.etsi.org/deliver/etsi_ts/119300_119399/119312/01.05.01_60/ts_119312v010501p.pdf) defines trust-service suites, recommendations, and transition periods.
* [CA/B Forum TLS Baseline Requirements v2.2.8 (2026-06-16)](https://github.com/cabforum/servercert/tree/refs/tags/BRs/v2.2.8) defines a distinct publicly trusted TLS scope and algorithm constraints.
* [BSI TR-03116-4, Stand 2025](https://www.bsi.bund.de/SharedDocs/Downloads/DE/BSI/Publikationen/TechnischeRichtlinien/TR03116/BSI-TR-03116-4.pdf) defines German eID-specific requirements and transitions.
* [FIPS 186-5 (2023-02-03)](https://doi.org/10.6028/NIST.FIPS.186-5) specifies digital-signature techniques and parameters within its scope.

The differences affect executable policy. In the cited editions, ETSI recommends RSA-PSS and includes Brainpool and NIST curves with time-bounded legacy choices; the TLS Baseline Requirements use a narrower subscriber-key set and constrain RSA-PSS parameters; BSI's eID profile defines different X.509 signature choices and transitions; and FIPS 186-5 permits EdDSA and an RSA-PSS salt-length range that an ecosystem profile may narrow. These summaries apply only within each document's stated scope and applicability rules.

An allow-list copied from one edition cannot safely represent all of these scopes. A standards citation also does not establish certification. [NIST CMVP](https://csrc.nist.gov/projects/cryptographic-module-validation-program) validation and [Common Criteria Part 1, CC:2022 Revision 1](https://www.commoncriteriaportal.org/files/ccfiles/CC2022PART1R1.pdf) evaluation concern concrete modules, products, configurations, operational environments, and evidence. An enum token or policy snapshot cannot itself be “FIPS certified,” “eIDAS certified,” “ETSI certified,” or “Common Criteria certified.” This ADR makes no FIPS, eIDAS, ETSI, Common Criteria, or WebPKI certification or conformance claim.

[ADR 0003](0003-use-enriched-enums-for-stable-algorithm-wire-identities.md) places stable intrinsic identities in separate Java enriched enums. Deployment governance needs a mutable-in-time but immutable-by-version layer that selects those identities, constrains their use, and binds a decision to evidence without allowing configuration to become executable code.

CertificateProfile v1 already has a normative identity contract in [ADR 0001](0001-use-content-addressed-yaml-for-certificate-profiles.md). Its identity and a deployment-policy decision solve different problems and must remain independent.

## Decision

Use strictly admitted, immutable YAML deployment-policy snapshots to define profile-scoped deployment permissions. A snapshot selects exact explicit enum wire tokens from ADR 0003 and invokes only rules from a closed, versioned catalog of compiled Java validators.

### Closed policy language

YAML is declarative policy data, not an algorithm or programming language.

A policy snapshot may contain only schema-defined values such as:

* policy namespace and schema version;
* policy edition and applicability scope;
* exact subject-SPKI, issuer-signature-suite, KMS/provider-mechanism, CVC, SSH, and content-hash wire tokens where relevant to that profile;
* typed parameters for named compiled validators;
* effective intervals or transition horizons;
* required provider/module characteristics and evidence classes; and
* citations and governance metadata.

YAML must not define new algorithms. It must not contain arbitrary expressions, scripts, reflection targets, class names, dynamic method names, network references to evaluate, or regular expressions. Policy evaluation has no network access. Unknown fields, unknown or miscased tokens, unknown rule identifiers, unsupported schema/catalog versions, and parameters outside a rule's closed typed schema are rejected at admission.

The validator catalog is compiled Java code with a stable catalog identifier and semantic version. Each rule has a stable rule identifier, a closed parameter schema, deterministic semantics, and an explicit compatibility declaration for policy schema versions. Policy snapshots declare the required catalog version or compatible bounded range. Admission rejects policies when the running evaluator cannot prove policy-schema, rule, parameter, and catalog compatibility. A catalog upgrade must not silently reinterpret an already identified snapshot.

### Strict admission, canonical identity, and publication

Admission must use a strict YAML parser and a versioned schema. It rejects duplicate keys, aliases, anchors, merge keys, custom tags, multiple documents, explicit null where not expressly allowed, scalar coercion, unknown members, duplicate set members, invalid Unicode, and values outside declared bounds. Defaults, ordered-list semantics, and unordered-set semantics must be explicit per schema field.

After strict admission, the semantic policy model is normalized according to its schema, serialized to deterministic canonical bytes, and content-addressed with a namespaced digest. Raw YAML presentation is not the snapshot identity. The exact canonicalization algorithm, digest namespace, and golden fixtures must be fixed by executable requirements before implementation; changing identity semantics requires a new policy identity namespace.

Governed publication produces a manifest that binds at least the policy alias, policy snapshot ID, policy schema version, validator catalog compatibility, publication sequence or equivalent rollback value, signature metadata, and referenced immutable evidence snapshot IDs. Activatable manifests and policy snapshots must be signed by an authorized publication identity and verified against environment-specific trust anchors before activation. Trusted distribution must protect the signed manifest, snapshots, trust-anchor updates, and evaluator/catalog artifacts.

Rollback protection is mandatory. The runtime records the highest accepted publication sequence, epoch, or other approved monotonic state for each policy namespace and rejects older, revoked, expired, or conflicting publication state unless an explicitly authorized break-glass rollback is separately authenticated and audited. A content hash or Git history alone is not rollback protection.

Git is the governed authoring, review, history, and publication channel under [ADR 0002](0002-use-git-backed-governed-event-store-for-certificate-profile-lifecycle.md). It is not the runtime policy database, online decision store, trust anchor, or sole proof of freshness. Runtime evaluation uses locally available, verified immutable snapshots and manifests. Git branch protection and signed publication can add controls but do not replace snapshot signatures, trusted distribution, or rollback state.

### Deterministic fail-closed evaluation

Every evaluation receives an explicit evaluation instant; rules must not read an implicit wall clock. The decision input consists only of the admitted policy snapshot, explicit operation/context data, the exact evaluator and validator-catalog version, the explicit instant, and immutable evidence snapshots identified by content IDs. Missing, stale, revoked, incompatible, ambiguous, or unverifiable policy or evidence causes a fail-closed result.

Evidence about providers, modules, certificates, evaluated configurations, standards editions, or deployment state is captured as immutable evidence snapshots. Evidence validity and freshness are evaluated at the explicit instant. A token, vendor claim, certificate label, or policy assertion never substitutes for verification of the concrete module/product/configuration and its evidence.

Reload follows `stage -> validate -> atomically swap`:

1. fetch or receive candidate publication artifacts without changing the active set;
2. verify strict schema admission, content IDs, signatures, trust chain, rollback state, catalog compatibility, rule parameters, referenced evidence, and a complete deterministic evaluation preflight;
3. stage the complete immutable policy/evidence set;
4. atomically replace the active set only after all checks succeed; and
5. retain the prior known-good set and record the rejection if any candidate check fails.

Partial activation and mixed old/new snapshot sets are forbidden. A reload failure must not weaken or partially mutate the active policy.

Each policy decision emits or binds immutable audit evidence containing at least:

* CertificateProfile ID or other governed operation/profile ID;
* policy snapshot ID;
* all evidence snapshot IDs used;
* evaluator version and validator-catalog version;
* explicit evaluation instant; and
* result and stable reason/rule identifiers.

The audit binding must be sufficient to reproduce which immutable inputs and compiled semantics produced the result. It must not imply that later recreation is possible if required artifacts are not retained; retention is a separate operational requirement.

### CertificateProfile v1 boundary

Policy admission and evaluation occur outside CertificateProfile v1 identity. The v1 YAML field `publicKeyAlgorithms`, its tokens `EC_P256` and `RSA_3072`, the normative canonical JSON, digest, and profile ID remain unchanged.

A policy snapshot ID must be bound alongside the CertificateProfile ID at issuance or another governed decision; it must not be inserted into CertificateProfile v1 canonical content. Adding `policy`, `policySnapshotId`, evidence IDs, evaluator versions, deployment permissions, or any other policy field to CertificateProfile v1 is forbidden. Such an identity-affecting schema change requires an explicitly governed new CertificateProfile identity namespace under ADR 0001.

## Consequences

Policy editions, transition dates, standards citations, deployment permissions, and evidence requirements can change without mutating stable algorithm identities or existing CertificateProfile v1 identities.

Closed compiled validators provide reviewable Java semantics and prevent YAML from becoming a remote-code-execution or unbounded expression surface. New rule semantics require a reviewed catalog release rather than configuration-only invention.

Content addressing, signatures, trusted manifests, and rollback state make policy activation traceable and resistant to tampering and replay, but they introduce key management, trust-anchor, publication, retention, and recovery obligations.

Deterministic explicit-time evaluation and immutable evidence snapshots improve reproducibility. They also require callers to supply the instant and evidence explicitly and require the organization to govern evidence acquisition and freshness.

Strict compatibility checks may reject a policy after an evaluator/catalog change. That fail-closed behavior is intentional; migration requires explicit republishing or a compatibility declaration, not silent reinterpretation.

A policy decision means only that the compiled evaluator reached a result for the identified inputs, edition, instant, and evidence. It is not a certification or general conformance statement.

## Alternatives Considered

Embedding mutable standards approvals, dates, and certification flags in enums was rejected because those facts are profile-, time-, deployment-, and evidence-scoped.

Allowing YAML to define algorithms was rejected because it would bypass the compiled intrinsic taxonomy and permit identities without reviewed protocol semantics.

A general expression language, scripts, reflection, network lookups, or regular expressions in policy was rejected because it expands the attack surface, impairs deterministic review, and makes fail-closed compatibility difficult.

Using Git directly as the runtime policy database was rejected because Git is not an online decision store, freshness oracle, trust anchor, or rollback-protection mechanism.

Adding deployment policy to CertificateProfile v1 was rejected because it would conflate stable profile identity with mutable deployment eligibility and would change the v1 identity contract.

## Evidence

* [ADR 0001 — Use content-addressed YAML for certificate profiles](0001-use-content-addressed-yaml-for-certificate-profiles.md)
* [ADR 0002 — Use a Git-backed governed event store for certificate profile registry lifecycle](0002-use-git-backed-governed-event-store-for-certificate-profile-lifecycle.md)
* [ADR 0003 — Use enriched enums for stable algorithm wire identities](0003-use-enriched-enums-for-stable-algorithm-wire-identities.md)
* [CertificateProfile v1 executable requirements](../../features/x509/certificate-profile-integrity.feature)

## Open Follow-up Decisions

* Define the policy schema namespace, exact canonicalization, digest, identifier grammar, and golden fixtures.
* Select signing algorithms, publication roles, trust-anchor custody and rotation, revocation handling, and environment-specific trusted distribution.
* Define the monotonic rollback state, disaster recovery, and authorization/evidence required for break-glass rollback.
* Define validator catalog versioning and compatibility rules precisely, including artifact supply-chain verification.
* Define evidence snapshot schemas, issuers, freshness rules, retention, and revocation sources for each deployment profile.
* Define the first named deployment policies and their exact edition-scoped requirements through Gherkin before implementation.
