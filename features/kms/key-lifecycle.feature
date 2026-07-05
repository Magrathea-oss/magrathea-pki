Feature: KMS Key Lifecycle Management

  Business Need:
  As a KMS consumer
  I want to manage the full lifecycle of cryptographic keys
  So that keys can be generated, imported, used, and retired securely

  Rules:
  - A generated key is created with a specific algorithm, usage, and label
  - A KeyHandle uniquely identifies a key within the KMS
  - Key metadata is accessible via KeyHandle at any time after creation
  - A disabled key cannot be used for sign/verify/encrypt/decrypt operations
  - A destroyed key is permanently removed and its KeyHandle becomes invalid

  @functional-requirement @not-implemented
  Scenario: Generate a signing key
    Given a KMS client requests key generation
    When the client generates a key with:
      | algorithm | EC_P256           |
      | usage     | SIGN              |
      | label     | "code-signing-key" |
    Then the KMS returns a KeyHandle
    And the key metadata includes:
      | algorithm | EC_P256           |
      | usage     | SIGN              |
      | label     | "code-signing-key" |
      | state     | ENABLED           |

  @functional-requirement @not-implemented
  Scenario: Generate an encryption key
    Given a KMS client requests key generation
    When the client generates a key with:
      | algorithm | AES_256_GCM       |
      | usage     | ENCRYPT_DECRYPT   |
      | label     | "data-encryption-key" |
    Then the KMS returns a KeyHandle
    And the key metadata includes:
      | algorithm | AES_256_GCM       |
      | usage     | ENCRYPT_DECRYPT   |
      | label     | "data-encryption-key" |
      | state     | ENABLED           |

  @functional-requirement @not-implemented
  Scenario: Import an existing key
    Given the client holds an existing key material for algorithm RSA_2048 with usage SIGN
    When the client imports the key material with label "imported-signing-key"
    Then the KMS returns a KeyHandle
    And the key metadata includes:
      | algorithm | RSA_2048          |
      | usage     | SIGN              |
      | label     | "imported-signing-key" |
      | state     | ENABLED           |

  @functional-requirement @not-implemented
  Scenario: List all keys
    Given the KMS contains keys with labels "code-signing-key", "data-encryption-key", and "imported-signing-key"
    When the client lists all keys
    Then the returned list contains 3 entries
    And each entry has a KeyHandle and metadata

  @functional-requirement @not-implemented
  Scenario: Read key metadata by KeyHandle
    Given a key exists with label "code-signing-key" and algorithm EC_P256
    When the client reads metadata for the key's KeyHandle
    Then the returned metadata includes:
      | algorithm | EC_P256           |
      | usage     | SIGN              |
      | label     | "code-signing-key" |
      | state     | ENABLED           |

  @functional-requirement @not-implemented
  Scenario: Disable a key prevents its use
    Given a key exists with label "code-signing-key" in state ENABLED
    When the client disables the key
    Then the key metadata shows state DISABLED
    And a sign operation with the disabled key is denied

  @functional-requirement @not-implemented
  Scenario: Destroy a key removes it permanently
    Given a key exists with label "code-signing-key" and KeyHandle
    When the client destroys the key
    Then the key metadata is no longer accessible
    And the KeyHandle is invalid for any operation
