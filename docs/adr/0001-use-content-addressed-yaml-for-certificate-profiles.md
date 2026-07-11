# ADR 0001 — Use content-addressed YAML for certificate profiles

## Status

Accepted

## Context

Certificate profiles define security-relevant X.509 certificate issuance behavior. They need stable identity, reproducible lookup, and tamper-evident references across environments.

Profiles are authored and stored as YAML resources for readability, migration/versioning, and operational review. However, raw YAML bytes can vary without changing the meaning of a profile, for example through formatting, key ordering, comments, or whitespace.

A content hash is only useful for tamper detection when the system compares the loaded profile with a trusted expected profile ID or trusted reference. The expected reference must therefore be separate from the hashed profile content and protected according to the operational threat model.

## Decision

Certificate profiles are immutable, content-addressed YAML resources. A `CertificateProfileId` is derived from a deterministic canonical representation of the semantic `CertificateProfile` model, not directly from raw YAML bytes.

### CertificateProfile v1 identity contract (2026-07-11)

The following contract is normative for the `x509-profile-v1-sha256` identity namespace.

#### Semantic schema

An accepted source document represents one mapping with these fields:

* `subjectTemplate` is required. It is a Unicode string that must be non-empty and, after NFC normalization, contain from 1 through 1024 UTF-8 bytes. NUL, C0 controls (`U+0000`–`U+001F`), C1 controls (`U+007F`–`U+009F`), unpaired surrogates, and other malformed Unicode are rejected.
* `publicKeyAlgorithms` is required and is a non-empty, duplicate-free, unordered set of enum tokens.
* `validityDays` is required and is a YAML-native integer from 1 through 36500, inclusive.
* `keyUsages` is required and is a non-empty, duplicate-free, unordered set of enum tokens.
* `extendedKeyUsages` is optional and is a duplicate-free, unordered set of enum tokens. Its default is `[]`; an explicit empty set is allowed and means that this field represents no EKU restriction.
* `basicConstraints` is optional and, when present, is an object containing only the optional `ca` field. An absent `basicConstraints` object, an empty object, or an absent `ca` field defaults to `{"ca":false}`. When present, `ca` must be a YAML-native Boolean.

After default expansion, the canonical object always has exactly these six top-level fields: `subjectTemplate`, `publicKeyAlgorithms`, `validityDays`, `keyUsages`, `extendedKeyUsages`, and `basicConstraints`.

The initial enum vocabularies are closed, ASCII, and case-sensitive:

* `publicKeyAlgorithms`: `EC_P256`, `RSA_3072`;
* `keyUsages`: `digitalSignature`, `contentCommitment`, `keyEncipherment`, `dataEncipherment`, `keyAgreement`, `keyCertSign`, `cRLSign`, `encipherOnly`, `decipherOnly`;
* `extendedKeyUsages`: `serverAuth`, `clientAuth`, `codeSigning`, `emailProtection`, `timeStamping`, `ocspSigning`, `anyExtendedKeyUsage`.

Schema admission is strict. It rejects:

* explicit `null` anywhere; missing required fields; wrong YAML-native types; and scalar coercion, including quoted values such as `"397"` or `"false"` where an integer or Boolean is required;
* unknown top-level fields and extra `basicConstraints` members;
* unknown or miscased enum tokens;
* duplicate mapping keys and duplicate collection members;
* YAML aliases, anchors, merge keys, custom tags, and multiple YAML documents.

Defaults apply only when optional fields or members are absent. Duplicate members are rejected, not deduplicated.

#### Identity normalization and canonical serialization

`subjectTemplate` identity normalization is NFC only. Case, all accepted whitespace, punctuation, and placeholder spelling are preserved exactly. Template and distinguished-name grammar are opaque to this identity contract solely to make identity deterministic; this does not establish that a template is valid or safe for issuance. Malformed Unicode is rejected.

`publicKeyAlgorithms`, `keyUsages`, and `extendedKeyUsages` are the only collections in v1 and are duplicate-free unordered sets. Their tokens are validated before sorting, then sorted ascending by unsigned lexicographic comparison of their UTF-8 octets. This rule must not be generalized to a future field whose semantics require an ordered list.

The identity pipeline is:

```text
YAML parse -> schema validation -> default expansion -> subjectTemplate NFC -> set sorting -> RFC 8785 JCS -> SHA-256 -> profile ID
```

RFC 8785 JSON Canonicalization Scheme (JCS) controls object-member ordering, string escaping, number representation, and JSON whitespace; JCS does not sort arrays. The SHA-256 input is exactly the UTF-8 bytes of the resulting JCS JSON, with no byte-order mark, trailing newline, or other prefix. The profile-ID namespace prefix is added only after hashing and is not part of the hash input.

A v1 profile ID must match this whole-string grammar, without trimming:

```text
^x509-profile-v1-sha256-[0-9a-f]{64}$
```

The digest is lowercase SHA-256 hexadecimal. The complete ID is exactly 87 ASCII characters. Every public construction path for `CertificateProfileId` must enforce this grammar.

#### Golden identity fixture

The normative canonical JSON fixture is exactly the following single line, without a BOM or trailing newline:

```json
{"basicConstraints":{"ca":false},"extendedKeyUsages":["serverAuth"],"keyUsages":["digitalSignature","keyEncipherment"],"publicKeyAlgorithms":["EC_P256","RSA_3072"],"subjectTemplate":"CN=${commonName},O=Example PKI","validityDays":397}
```

Its digest and profile ID are:

```text
d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee
x509-profile-v1-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee
```

The prior `6f1ed` fixture is not reproducible under this contract and must not be treated as a v1 golden identity.

#### Identity and issuance-policy boundary

Canonicalization decides stable identity only. It does not decide profile safety, semantic eligibility, or authorization for issuance. Cross-field constraints such as CA and `keyCertSign` consistency, validity policy, EKU applicability, public-key suitability, subject-template grammar and substitution, lifecycle eligibility, and other security rules belong to separate issuance-policy validation after identity formation. Issuance must be rejected when a required policy rule is unspecified or unsatisfied. In particular, actual certificate issuance remains blocked until subject-template grammar, substitution, and security validation are separately approved.

#### Compatibility and versioning

Any identity-affecting change to fields, defaults, normalization, set semantics, canonical serialization, or the hash algorithm requires a new identity namespace with a v2 prefix. Adding accepted enum tokens preserves the canonical bytes and IDs of already accepted profiles, but changes the acceptance boundary and therefore requires explicit governance. Existing IDs are immutable. Manifest aliases and profile history must preserve old IDs when an alias advances to a new profile.

### Trusted manifest, lifecycle, and audit

Expected profile IDs are stored in a separate trusted YAML manifest, not inside the hashed profile file. The intended layout remains:

```text
profiles/<name>.yaml
profiles/profiles.manifest.yaml
```

The manifest maps human-readable aliases or names to active and previous immutable profile IDs. Semantic profile changes create new IDs; existing profile content remains immutable. Human aliases may move to new active IDs while preserving references to previous IDs.

The first release does not require the manifest to be signed, but its format must be prepared for later signing. Potential hardening includes:

* `profiles/profiles.manifest.sig`;
* software signatures for development environments;
* HSM-backed signatures for production environments;
* Git signed commits as optional additional repository-level protection.

Before issuance is eligible, the intended behavior is to load the profile, compute its ID through the normative pipeline, and compare it with the expected ID from the trusted manifest or another trusted reference. A mismatch must reject issuance and emit a `PROFILE_INTEGRITY_FAILED` audit event containing:

* `profilePath`;
* `expectedProfileId`;
* `computedProfileId`;
* actor or system identity;
* timestamp;
* reason.

The lifecycle states remain:

* `draft`;
* `active`;
* `deprecated`;
* `revoked`;
* `archived`.

These statements define required and intended behavior; they do not claim that profile parsing, canonicalization, manifest verification, audit emission, lifecycle enforcement, or issuance has been implemented or semantically validated.

## Consequences

The contract permits stable profile identity across YAML representations that admit the same semantic model while rejecting ambiguous or unsupported YAML constructs.

Certificate issuance can reference immutable profile IDs instead of mutable names or paths, and any identity-affecting semantic profile change creates a distinct addressable resource.

Strict parsing, explicit defaults, NFC normalization, set sorting, JCS serialization, and a versioned namespace make the identity bytes reproducible. Ordered collections introduced in a later schema will require their own explicit semantics.

Tamper detection still depends on protecting or independently trusting the manifest or expected-ID reference. An attacker able to alter both profile content and its trusted reference can bypass comparison unless manifest distribution and signing are hardened.

Lifecycle and alias handling must preserve immutable historical references so previously issued certificates remain traceable to the exact profile ID used at issuance time.

Stable identity does not make a profile safe to issue. Separate, fail-closed issuance-policy validation remains necessary.

## Alternatives Considered

Hashing raw YAML bytes was rejected because semantically irrelevant formatting, comments, and mapping order would change identity.

Embedding the expected ID inside the hashed profile was rejected because it is circular and does not provide an independent trusted reference.

Treating JCS as sufficient to impose unordered-set semantics was rejected because JCS does not sort arrays; set validation and sorting must occur before JCS serialization.

## Open Follow-up Decisions

Decide the first-release trust and distribution model for `profiles/profiles.manifest.yaml`, including whether unsigned manifests are acceptable in each environment.

Decide when to require stronger integrity protection such as `profiles/profiles.manifest.sig`, software signatures, HSM-backed production signatures, Git signed commits, append-only audit records, or transparency logs.

Define exact lifecycle edge cases for transitions among `draft`, `active`, `deprecated`, `revoked`, and `archived`, including alias movement, rollback, and issuance behavior for deprecated or revoked profiles.
