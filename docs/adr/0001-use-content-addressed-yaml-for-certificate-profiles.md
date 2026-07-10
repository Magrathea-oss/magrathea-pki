# ADR 0001 — Use content-addressed YAML for certificate profiles

## Status

Accepted

## Context

Certificate profiles define security-relevant X.509 certificate issuance behavior. They need stable identity, reproducible lookup, and tamper-evident references across environments.

Profiles are authored and stored as YAML resources for readability, migration/versioning, and operational review. However, raw YAML bytes can vary without changing the meaning of a profile, for example through formatting, key ordering, comments, or whitespace.

A content hash is only useful for tamper detection when the system compares the loaded profile with a trusted expected profile ID or trusted reference. The expected reference must therefore be separate from the hashed profile content and protected according to the operational threat model.

## Decision

Certificate profiles are immutable, content-addressed YAML resources.

A `CertificateProfileId` is derived from a deterministic canonical representation of the semantic `CertificateProfile` model, not directly from raw YAML bytes.

The profile identity pipeline is:

```text
YAML -> parse -> schema validation -> CertificateProfile model -> normalize fields -> deterministic canonical JSON -> SHA-256 -> profile ID
```

The initial profile ID format is:

```text
x509-profile-v1-sha256-<digest>
```

Canonicalization rules for the `x509-profile-v1` identity contract are:

* deterministic field order;
* lists are sorted only when the list is semantically unordered;
* defaults are expanded before hashing;
* YAML comments and whitespace are ignored;
* YAML aliases are forbidden;
* unknown fields are forbidden by schema validation;
* timestamps are excluded from hashed profile content.

Expected profile IDs are stored in a separate YAML manifest, not inside the hashed profile file. The intended file layout is:

```text
profiles/<name>.yaml
profiles/profiles.manifest.yaml
```

The manifest maps human-readable aliases or names to active and previous immutable profile IDs. Semantic profile changes create a new `CertificateProfileId`; existing profile content remains immutable. Human aliases may move to a new active profile ID while preserving references to previous IDs.

The first release does not require the manifest to be signed, but the manifest format must be prepared for later signing. Later hardening may add:

* `profiles/profiles.manifest.sig`;
* software signatures for development environments;
* HSM-backed signatures for production environments;
* Git signed commits as optional additional repository-level protection.

Before certificate issuance, the system must load the profile, recompute its profile ID through the canonical pipeline, and compare the computed ID with the expected ID from the manifest or trusted reference. On mismatch, the profile is rejected for issuance and the system emits a `PROFILE_INTEGRITY_FAILED` audit event containing:

* `profilePath`;
* `expectedProfileId`;
* `computedProfileId`;
* actor or system identity;
* timestamp;
* reason.

The profile lifecycle states are:

* `draft`;
* `active`;
* `deprecated`;
* `revoked`;
* `archived`.

A planned Gherkin scenario will cover rejecting a tampered certificate profile before issuance.

## Consequences

Profile identity is stable across semantically equivalent YAML representations.

Certificate issuance can reference immutable profile IDs instead of mutable profile names or paths.

Any semantic profile change creates a distinct addressable resource.

Canonicalization is part of the profile identity contract and must be versioned. Changing canonicalization rules may require a new profile ID version prefix.

Profile YAML is easier to review and migrate, while comments, formatting, aliases, unknown fields, and operational timestamps cannot silently alter or contaminate the identity calculation.

Tamper detection depends on protecting or independently trusting the manifest or expected profile ID reference. An attacker who can change both the profile file and the trusted reference may still bypass hash comparison unless manifest distribution and signing are hardened.

Lifecycle and alias handling must preserve immutable historical references so previously issued certificates remain traceable to the exact profile ID used at issuance time.

## Open Follow-up Decisions

Decide the first-release trust and distribution model for `profiles/profiles.manifest.yaml`, including whether unsigned manifests are acceptable in each environment.

Decide when to require stronger integrity protection such as `profiles/profiles.manifest.sig`, software signatures, HSM-backed production signatures, Git signed commits, append-only audit records, or transparency logs.

Define exact lifecycle edge cases for transitions among `draft`, `active`, `deprecated`, `revoked`, and `archived`, including alias movement, rollback, and issuance behavior for deprecated or revoked profiles.
