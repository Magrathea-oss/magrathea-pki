@x509 @certificate-profile @integrity @adr-0001 @uc-x509-profile-integrity
Feature: Content-addressed YAML certificate profile integrity

  Business Need:
  As a PKI operator
  I want X.509 certificate profiles to be verified against trusted content-addressed identifiers
  So that certificate issuance cannot use a tampered or semantically ambiguous profile

  Rules:
  - Certificate profiles are immutable YAML resources referenced by a separate manifest at "profiles/profiles.manifest.yaml"
  - An admitted v1 profile has required fields "subjectTemplate", "publicKeyAlgorithms", "validityDays", and "keyUsages", plus optional "extendedKeyUsages" and "basicConstraints"
  - After default expansion, the canonical CertificateProfile model has exactly those six fields
  - Schema admission rejects explicit nulls, wrong native types, unknown fields, unknown or miscased enum tokens, duplicate mapping keys, duplicate set members, aliases, anchors, merge keys, custom tags, and multiple YAML documents
  - Identity normalization applies NFC only to "subjectTemplate" and sorts the three duplicate-free unordered enum sets by unsigned UTF-8 byte order
  - Deterministic canonical JSON uses RFC 8785 JCS, and SHA-256 hashes exactly its UTF-8 bytes without a byte-order mark or trailing newline
  - A v1 profile ID matches "^x509-profile-v1-sha256-[0-9a-f]{64}$" as a whole string without trimming
  - A computed profile ID mismatch rejects the profile for certificate issuance and records a PROFILE_INTEGRITY_FAILED audit event
  - Profile identity formation does not establish semantic eligibility or authorization for certificate issuance
  - The first release does not require manifest signatures

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-profile-integrity-001
  Scenario: Reproduce the approved TLS server baseline profile identity
    Given the profile manifest "profiles/profiles.manifest.yaml" contains an approved profile entry:
      | profilePath                            | expectedProfileId                                                        | lifecycleState |
      | profiles/x509/tls-server-baseline.yaml | x509-profile-v1-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee | active         |
    And the YAML profile "profiles/x509/tls-server-baseline.yaml" does not contain its expected profile ID
    And the YAML profile defines exactly this semantic CertificateProfile v1 content:
      | subjectTemplate     | CN=${commonName},O=Example PKI            |
      | publicKeyAlgorithms | EC_P256,RSA_3072                          |
      | validityDays        | 397                                       |
      | keyUsages           | digitalSignature,keyEncipherment          |
      | extendedKeyUsages   | serverAuth                                |
      | basicConstraints.ca | false                                     |
    When Magrathea verifies the profile identity against the manifest entry
    Then the canonical JSON is exactly this single UTF-8 line without a byte-order mark or trailing newline:
      """
      {"basicConstraints":{"ca":false},"extendedKeyUsages":["serverAuth"],"keyUsages":["digitalSignature","keyEncipherment"],"publicKeyAlgorithms":["EC_P256","RSA_3072"],"subjectTemplate":"CN=${commonName},O=Example PKI","validityDays":397}
      """
    And the SHA-256 digest is "d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee"
    And the computed profile ID is "x509-profile-v1-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee"
    And the profile passes the integrity gate for subsequent issuance-policy validation
    And no PROFILE_INTEGRITY_FAILED audit event is recorded for "profiles/x509/tls-server-baseline.yaml"

  @functional-requirement @not-implemented @req-x509-profile-integrity-002
  Scenario: Reject a semantically changed TLS server baseline profile
    Given the trusted expected profile ID for "profiles/x509/tls-server-baseline.yaml" is "x509-profile-v1-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee"
    And the admitted YAML profile has the approved six-field TLS server baseline content except that "validityDays" is 825 instead of 397
    When Magrathea verifies the profile identity against the manifest entry
    Then the computed profile ID differs from "x509-profile-v1-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee"
    And the profile is rejected for certificate issuance
    And a PROFILE_INTEGRITY_FAILED audit event records the profile path, expected profile ID, computed profile ID, actor or system identity, timestamp, and mismatch reason

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-profile-integrity-003
  Scenario: Preserve identity across non-semantic YAML representation changes
    Given the trusted expected profile ID for "profiles/x509/tls-server-baseline.yaml" is "x509-profile-v1-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee"
    And the YAML profile differs from the approved TLS server baseline only by comments, indentation, blank lines, quoting style, and mapping-field order
    And its admitted six-field CertificateProfile model is semantically equal to the approved TLS server baseline
    When Magrathea verifies the profile identity against the manifest entry
    Then the canonical JSON equals the normative TLS server baseline canonical JSON
    And the computed profile ID is "x509-profile-v1-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee"
    And the profile passes the integrity gate for subsequent issuance-policy validation

  @functional-requirement @not-implemented @req-x509-profile-integrity-004
  Scenario: Reject an unknown profile field before identity formation
    Given the YAML profile "profiles/x509/tls-server-baseline.yaml" contains the six v1 fields and an unknown top-level field "allowWildcardInternalNames"
    When Magrathea admits the YAML profile for identity formation
    Then schema admission fails because "allowWildcardInternalNames" is not a CertificateProfile v1 field
    And no CertificateProfile model, canonical JSON, digest, or profile ID is produced
    And the profile cannot pass the integrity gate

  @functional-requirement @not-implemented @req-x509-profile-integrity-005
  Scenario: Reject YAML aliases before identity formation
    Given the YAML profile "profiles/x509/tls-server-baseline.yaml" uses an anchor and alias to reuse a profile value
    When Magrathea admits the YAML profile for identity formation
    Then schema admission fails because YAML anchors and aliases are not allowed
    And no CertificateProfile model, canonical JSON, digest, or profile ID is produced
    And the profile cannot pass the integrity gate

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-profile-integrity-006
  Scenario: Expand absent optional fields to the same identity as explicit defaults
    Given one admitted YAML profile omits "extendedKeyUsages" and "basicConstraints"
    And another otherwise identical admitted YAML profile contains "extendedKeyUsages: []" and "basicConstraints: {ca: false}"
    When Magrathea forms the identity of each profile
    Then both canonical models contain "extendedKeyUsages" as an empty set and "basicConstraints.ca" as false
    And both profiles produce identical canonical JSON, SHA-256 digests, and profile IDs

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-profile-integrity-007
  Scenario: Preserve identity when unordered set members are reordered
    Given the trusted expected profile ID for "profiles/x509/tls-server-baseline.yaml" is "x509-profile-v1-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee"
    And the admitted YAML profile has the approved TLS server baseline content with "publicKeyAlgorithms" ordered as "RSA_3072,EC_P256"
    And its "keyUsages" are ordered as "keyEncipherment,digitalSignature"
    When Magrathea verifies the profile identity against the manifest entry
    Then the canonical arrays are ordered as:
      | field               | canonical members                         |
      | publicKeyAlgorithms | EC_P256,RSA_3072                          |
      | keyUsages           | digitalSignature,keyEncipherment          |
      | extendedKeyUsages   | serverAuth                                |
    And the computed profile ID is "x509-profile-v1-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee"

  @functional-requirement @not-implemented @req-x509-profile-integrity-008
  Scenario Outline: Reject explicit null values before default expansion
    Given an otherwise valid YAML profile explicitly sets "<fieldPath>" to null
    When Magrathea admits the YAML profile for identity formation
    Then schema admission fails because explicit null is not an absent optional value
    And no CertificateProfile model, canonical JSON, digest, or profile ID is produced

    Examples:
      | fieldPath               |
      | subjectTemplate         |
      | extendedKeyUsages       |
      | basicConstraints.ca     |

  @functional-requirement @not-implemented @req-x509-profile-integrity-009
  Scenario: Reject duplicate YAML mapping keys before identity formation
    Given an otherwise valid YAML profile declares the "validityDays" mapping key twice
    When Magrathea admits the YAML profile for identity formation
    Then YAML admission fails because duplicate mapping keys are not allowed
    And no CertificateProfile model, canonical JSON, digest, or profile ID is produced

  @functional-requirement @not-implemented @req-x509-profile-integrity-010
  Scenario Outline: Reject duplicate members in unordered sets
    Given an otherwise valid YAML profile contains "<member>" twice in "<field>"
    When Magrathea admits the YAML profile for identity formation
    Then schema admission fails because "<field>" must be duplicate-free
    And the duplicate is not silently removed or hashed
    And no CertificateProfile model, canonical JSON, digest, or profile ID is produced

    Examples:
      | field               | member             |
      | publicKeyAlgorithms | EC_P256            |
      | keyUsages           | digitalSignature   |
      | extendedKeyUsages   | serverAuth         |

  @functional-requirement @not-implemented @req-x509-profile-integrity-011
  Scenario Outline: Reject unknown or miscased enum tokens
    Given an otherwise valid YAML profile contains enum token "<token>" in "<field>"
    When Magrathea admits the YAML profile for identity formation
    Then schema admission fails because "<token>" is not in the closed case-sensitive vocabulary for "<field>"
    And no CertificateProfile model, canonical JSON, digest, or profile ID is produced

    Examples:
      | field               | token             |
      | publicKeyAlgorithms | RSA_4096          |
      | publicKeyAlgorithms | ec_p256           |
      | keyUsages           | DigitalSignature  |
      | extendedKeyUsages   | OCSP_SIGNING      |

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-profile-integrity-012
  Scenario: Normalize canonically equivalent subject templates to NFC
    Given one admitted profile has subject template "CN=Café,O=Example PKI" using U+00E9
    And another otherwise identical admitted profile has subject template "CN=Café,O=Example PKI" using U+0065 followed by U+0301
    When Magrathea forms the identity of each profile
    Then both canonical models contain the NFC subject template "CN=Café,O=Example PKI"
    And both profiles produce identical canonical JSON, SHA-256 digests, and profile IDs

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-profile-integrity-013
  Scenario Outline: Preserve significant subject-template case and whitespace in identity
    Given the trusted TLS server baseline profile ID is "x509-profile-v1-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee"
    And an otherwise identical admitted profile uses subject template "<subjectTemplate>"
    When Magrathea verifies the profile identity against the trusted TLS server baseline profile ID
    Then the canonical JSON preserves the subject template exactly after NFC normalization
    And the computed profile ID differs from the trusted TLS server baseline profile ID
    And the profile is rejected by the integrity gate

    Examples:
      | subjectTemplate                       |
      | CN=${commonName},o=Example PKI        |
      | CN=${commonName}, O=Example PKI       |

  @functional-requirement @not-implemented @req-x509-profile-integrity-014
  Scenario Outline: Reject a malformed expected profile ID without trimming or comparison
    Given the manifest entry for "profiles/x509/tls-server-baseline.yaml" contains expected profile ID "<expectedProfileId>"
    When Magrathea validates the expected profile ID
    Then the manifest entry is rejected because the value does not match the complete v1 profile-ID grammar
    And the profile is not loaded, hashed, or compared with the malformed expected profile ID

    Examples:
      | expectedProfileId                                                        |
      | x509-profile-v2-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee |
      | x509-profile-v1-sha256-D40ED2A8C1F61164E3F540E7623608C9A8797A7AD1A657D4DFFBB661CD1999EE |
      | x509-profile-v1-sha256-d40ed2                                           |
      | x509-profile-v1-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee-extra |
