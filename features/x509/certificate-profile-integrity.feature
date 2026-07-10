@x509 @certificate-profile @integrity @not-implemented @uc-x509-profile-integrity
Feature: Content-addressed YAML certificate profile integrity

  Business Need:
  As a PKI operator
  I want X.509 certificate profiles to be verified against trusted content-addressed identifiers
  So that certificate issuance cannot use a tampered or semantically ambiguous profile

  Rules:
  - Certificate profiles are immutable YAML resources referenced by a separate manifest at "profiles/profiles.manifest.yaml"
  - The profile identifier has the format "x509-profile-v1-sha256-<digest>"
  - The identifier is computed from the canonical semantic CertificateProfile model, not from raw YAML bytes
  - The integrity pipeline is YAML parse, schema validation, CertificateProfile model creation, field normalization, deterministic canonical JSON, SHA-256, and profile ID comparison
  - A profile whose computed identifier differs from the manifest identifier is rejected for certificate issuance
  - A rejected profile records a PROFILE_INTEGRITY_FAILED audit event
  - The first release does not require manifest signatures

  @functional-requirement @not-implemented @req-x509-profile-integrity-001
  Scenario: Accept an unchanged approved YAML profile when the computed ID matches the manifest ID
    Given the profile manifest "profiles/profiles.manifest.yaml" contains an approved profile entry:
      | profilePath                            | expectedProfileId                                                        | lifecycleState |
      | profiles/x509/tls-server-baseline.yaml | x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76 | active         |
    And the YAML profile "profiles/x509/tls-server-baseline.yaml" does not contain its expected profile ID
    And the YAML profile semantically defines a TLS server certificate profile with:
      | subjectTemplate       | CN=${commonName},O=Example PKI          |
      | publicKeyAlgorithms   | EC_P256,RSA_3072                        |
      | validityDays          | 397                                     |
      | keyUsages             | digitalSignature,keyEncipherment        |
      | extendedKeyUsages     | serverAuth                              |
      | basicConstraints.ca   | false                                   |
    When Magrathea verifies the profile for certificate issuance
    Then the profile is parsed, schema validated, normalized, and converted to deterministic canonical JSON
    And the computed profile ID is "x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76"
    And the profile is accepted as eligible for certificate issuance
    And no PROFILE_INTEGRITY_FAILED audit event is recorded for "profiles/x509/tls-server-baseline.yaml"

  @functional-requirement @not-implemented @req-x509-profile-integrity-002
  Scenario: Reject a tampered YAML profile when the computed ID differs from the manifest ID
    Given the profile manifest "profiles/profiles.manifest.yaml" contains an approved profile entry:
      | profilePath                            | expectedProfileId                                                        | lifecycleState |
      | profiles/x509/tls-server-baseline.yaml | x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76 | active         |
    And the YAML profile "profiles/x509/tls-server-baseline.yaml" has been semantically changed after approval:
      | changedField        | approvedValue | currentValue |
      | validityDays        | 397           | 825          |
      | basicConstraints.ca | false         | true         |
    When Magrathea verifies the profile for certificate issuance
    Then the computed profile ID differs from "x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76"
    And the profile is rejected for certificate issuance
    And a PROFILE_INTEGRITY_FAILED audit event is recorded with:
      | profilePath       | profiles/x509/tls-server-baseline.yaml                                  |
      | expectedProfileId | x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76 |
      | failureReason     | manifest-id-mismatch                                                    |

  @functional-requirement @not-implemented @req-x509-profile-integrity-003
  Scenario: Ignore raw formatting and comment-only changes when canonical semantic content is unchanged
    Given the profile manifest "profiles/profiles.manifest.yaml" contains an approved profile entry:
      | profilePath                            | expectedProfileId                                                        | lifecycleState |
      | profiles/x509/tls-server-baseline.yaml | x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76 | active         |
    And the raw YAML bytes of "profiles/x509/tls-server-baseline.yaml" differ from the approved file only by comments, indentation, blank lines, quoting style, and field order
    And the parsed CertificateProfile model is semantically equivalent to the approved TLS server certificate profile
    When Magrathea verifies the profile for certificate issuance
    Then the deterministic canonical JSON is identical to the approved canonical JSON
    And the computed profile ID is "x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76"
    And the profile is accepted as eligible for certificate issuance
    And no PROFILE_INTEGRITY_FAILED audit event is recorded for "profiles/x509/tls-server-baseline.yaml"

  @functional-requirement @not-implemented @req-x509-profile-integrity-004
  Scenario: Reject a YAML profile with unknown fields before canonicalization
    Given the profile manifest "profiles/profiles.manifest.yaml" contains an approved profile entry for "profiles/x509/tls-server-baseline.yaml"
    And the YAML profile "profiles/x509/tls-server-baseline.yaml" contains an unknown field "allowWildcardInternalNames"
    When Magrathea verifies the profile for certificate issuance
    Then schema validation fails before a CertificateProfile model is accepted
    And no deterministic canonical JSON is produced for the profile
    And the profile is rejected for certificate issuance
    And a PROFILE_INTEGRITY_FAILED audit event is recorded with:
      | profilePath   | profiles/x509/tls-server-baseline.yaml |
      | failureReason | schema-validation-failed               |
      | detail        | unknown field allowWildcardInternalNames |

  @functional-requirement @not-implemented @req-x509-profile-integrity-005
  Scenario: Reject a YAML profile that uses aliases before canonicalization
    Given the profile manifest "profiles/profiles.manifest.yaml" contains an approved profile entry for "profiles/x509/tls-server-baseline.yaml"
    And the YAML profile "profiles/x509/tls-server-baseline.yaml" uses a YAML anchor and alias to reuse an extension block
    When Magrathea verifies the profile for certificate issuance
    Then YAML parsing or schema validation rejects the alias as a non-canonical profile construct
    And no CertificateProfile model is accepted for the profile
    And no deterministic canonical JSON is produced for the profile
    And the profile is rejected for certificate issuance
    And a PROFILE_INTEGRITY_FAILED audit event is recorded with:
      | profilePath   | profiles/x509/tls-server-baseline.yaml |
      | failureReason | canonicalization-violation             |
      | detail        | YAML aliases are not allowed            |
