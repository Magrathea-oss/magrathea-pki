Feature: KMS Key Encryption and Decryption

  Ability:
  As a KMS consumer
  I want to encrypt plaintext and decrypt ciphertext with symmetric keys
  So that data can be protected at rest and recovered by authorized consumers

  Rules:
  - A key with ENCRYPT_DECRYPT usage can encrypt plaintext and decrypt ciphertext
  - Encryption produces ciphertext that can be decrypted with the same key
  - A key without ENCRYPT_DECRYPT usage denies the encrypt operation
  - Decryption with a different key than the one used for encryption fails

  @functional-requirement @not-implemented
  Scenario: Encrypt plaintext with a symmetric key
    Given a key exists with algorithm AES_256_GCM and usage ENCRYPT_DECRYPT
    And the client has plaintext "hello-world"
    When the client encrypts the plaintext using the key's KeyHandle
    Then the KMS returns ciphertext
    And the ciphertext is not equal to the plaintext
    And the ciphertext is non-empty

  @functional-requirement @not-implemented
  Scenario: Decrypt ciphertext with the same key
    Given a key exists with algorithm AES_256_GCM and usage ENCRYPT_DECRYPT
    And the client has plaintext "hello-world"
    And the ciphertext for "hello-world" encrypted with the key exists
    When the client decrypts the ciphertext using the key's KeyHandle
    Then the KMS returns the original plaintext "hello-world"

  @functional-requirement @not-implemented
  Scenario: Encrypt denied for key without ENCRYPT_DECRYPT usage
    Given a key exists with algorithm EC_P256 and usage SIGN
    And the client has plaintext "hello-world"
    When the client attempts to encrypt the plaintext using the key's KeyHandle
    Then the KMS returns a policy denial error
    And the error message indicates the key usage does not permit encryption

  @functional-requirement @not-implemented
  Scenario: Decrypt with wrong key fails
    Given two keys exist:
      | KeyHandle | algorithm   | usage             | label                   |
      | KH-001    | AES_256_GCM | ENCRYPT_DECRYPT   | "encryption-key-1"      |
      | KH-002    | AES_256_GCM | ENCRYPT_DECRYPT   | "encryption-key-2"      |
    And ciphertext exists for plaintext "hello-world" encrypted by KH-001
    When the client decrypts the ciphertext using KH-002
    Then the KMS returns a decryption error
    And the error message indicates the ciphertext was not produced by this key
