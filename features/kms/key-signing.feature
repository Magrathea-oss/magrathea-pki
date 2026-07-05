Feature: KMS Key Signing and Signature Verification

  Ability:
  As a KMS consumer
  I want to sign digests with asymmetric keys and verify signatures
  So that data integrity and authenticity can be ensured

  Rules:
  - A key with SIGN usage can sign a digest and produce a signature
  - A signature can be verified against a digest using the corresponding public key
  - A key without SIGN usage denies the sign operation
  - Verification with a different key than the one used for signing fails

  @functional-requirement @not-implemented
  Scenario: Sign a digest with an asymmetric key
    Given a key exists with algorithm EC_P256 and usage SIGN
    And the client has a digest of "hello-world"
    When the client signs the digest using the key's KeyHandle
    Then the KMS returns a signature
    And the signature is non-empty

  @functional-requirement @not-implemented
  Scenario: Verify a signature against a digest
    Given a key exists with algorithm EC_P256 and usage SIGN
    And the client has a digest of "hello-world"
    And a valid signature for the digest exists from the key
    When the client verifies the signature against the digest using the key's KeyHandle
    Then the verification result is VALID

  @functional-requirement @not-implemented
  Scenario: Sign operation denied for key without SIGN usage
    Given a key exists with algorithm AES_256_GCM and usage ENCRYPT_DECRYPT
    And the client has a digest of "hello-world"
    When the client attempts to sign the digest using the key's KeyHandle
    Then the KMS returns a policy denial error
    And the error message indicates the key usage does not permit signing

  @functional-requirement @not-implemented
  Scenario: Verify with wrong key fails
    Given two keys exist:
      | KeyHandle | algorithm | usage | label          |
      | KH-001    | EC_P256   | SIGN  | "signing-key-1" |
      | KH-002    | EC_P256   | SIGN  | "signing-key-2" |
    And a signature exists for digest "hello-world" signed by KH-001
    When the client verifies the signature against the digest using KH-002
    Then the verification result is INVALID
