@x509 @algorithm-taxonomy @enriched-enum @adr-0003 @uc-x509-algorithm-taxonomy
Feature: Stable X.509 subject public-key profile wire identities

  Ability:
  As a PKI platform maintainer
  I want subject public-key profiles to have explicit stable wire identities
  So that Java refactoring cannot change persisted protocol meaning or collapse distinct algorithm taxonomies

  Rules:
  - An X.509 subject public-key profile is distinct from an issuer signature suite, KMS or provider mechanism, CVC algorithm, SSH algorithm, and content-hash algorithm
  - Every enriched-enum value has an explicit immutable case-sensitive wireToken independent of its Java enum name and ordinal
  - CertificateProfile v1 continues to admit the exact wire tokens "EC_P256" and "RSA_3072"
  - Parsing compares the complete wire token and never trims or folds case
  - Algorithm enums contain only stable intrinsic identity facts, never deployment policy, dates, approval state, or compliance evidence

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-subject-public-key-profile-001
  Scenario: Preserve the existing subject public-key profile wire vocabulary
    Given the closed X.509 subject public-key profile taxonomy
    When its enriched-enum values are inspected
    Then the complete wire-token vocabulary is:
      | wireToken |
      | EC_P256   |
      | RSA_3072  |
    And each value exposes its wire token as explicit immutable data
    And serialization uses the wire token rather than the Java enum name or ordinal

  @functional-requirement @not-implemented @req-x509-subject-public-key-profile-002
  Scenario Outline: Reject a subject public-key profile token unless it matches exactly
    Given the closed X.509 subject public-key profile wire-token vocabulary contains "EC_P256" and "RSA_3072"
    When a CertificateProfile v1 reader parses the YAML string scalar <yamlScalar>
    Then subject public-key profile parsing is rejected
    And the reader does not trim whitespace or fold case before comparison

    Examples:
      | yamlScalar    |
      | "ec_p256"    |
      | "Ec_P256"    |
      | " EC_P256"   |
      | "EC_P256 "   |
      | "RSA_3072\t" |

  @functional-requirement @not-implemented @req-x509-subject-public-key-profile-003
  Scenario Outline: Prevent a subject public-key profile from standing in for another algorithm role
    Given "EC_P256" identifies an X.509 subject public-key profile
    When a caller supplies that subject public-key profile as a value in the "<otherTaxonomy>" taxonomy
    Then the value is rejected before the governed operation is formed
    And no implicit cross-taxonomy conversion is performed

    Examples:
      | otherTaxonomy              |
      | X.509 issuer signature suite |
      | KMS or provider mechanism  |
      | CVC algorithm              |
      | SSH algorithm              |
      | content-hash algorithm     |

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-subject-public-key-profile-004
  Scenario: Rename the Java taxonomy without changing CertificateProfile v1 identity
    Given the normative CertificateProfile v1 golden fixture has subject public-key profile tokens "EC_P256" and "RSA_3072"
    And its approved profile ID is "x509-profile-v1-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee"
    When the Java type "PublicKeyAlgorithm" is renamed to "SubjectPublicKeyProfile"
    And the golden fixture identity is formed using the renamed type
    Then the YAML field remains "publicKeyAlgorithms"
    And both wire tokens remain unchanged
    And the canonical bytes are byte-for-byte equal to the approved CertificateProfile v1 golden bytes
    And the SHA-256 digest remains "d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee"
    And the profile ID remains "x509-profile-v1-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee"

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-subject-public-key-profile-005
  Scenario: Keep mutable deployment assertions out of the algorithm enum
    Given an enriched-enum value identifies an X.509 subject public-key profile
    When its declared data is inspected
    Then it contains no approval or deployment-permission flag
    And it contains no deprecation, transition, or security-horizon date
    And it contains no standards-edition or jurisdiction assertion
    And it contains no provider, module, configuration, certification, or compliance-evidence state
    And those mutable assertions can only be supplied through a separate governed deployment-policy and evidence decision
