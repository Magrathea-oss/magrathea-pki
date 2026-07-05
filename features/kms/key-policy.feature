Feature: KMS Key Policy Enforcement

  Business Need:
  As a KMS administrator
  I want to define and enforce key policies
  So that keys are used only for their intended purposes and within approved constraints

  Rules:
  - A key policy specifies allowed usages (SIGN, ENCRYPT_DECRYPT)
  - A key policy can require a specific backend type (HSM, SOFTWARE)
  - A key policy can require approval before use
  - Policy-denied operations produce audit events

  @functional-requirement @not-implemented
  Scenario: Policy allows only SIGN usage
    Given a key exists with algorithm RSA_2048 and usage SIGN
    And the key policy allows only SIGN operations
    When the client attempts to encrypt data with the key
    Then the KMS returns a policy denial error
    And the error indicates the operation is not permitted by key policy

  @functional-requirement @not-implemented
  Scenario: Policy denies ENCRYPT when only SIGN is allowed
    Given a key exists with algorithm EC_P256 and usage SIGN
    And the key policy allows only SIGN operations
    And the client has plaintext "hello-world"
    When the client attempts to encrypt the plaintext using the key's KeyHandle
    Then the KMS returns a policy denial error
    And the error message states "Operation not permitted: ENCRYPT is not allowed by key policy"

  @functional-requirement @not-implemented
  Scenario: Policy requires HSM backend
    Given a key exists with algorithm AES_256_GCM and usage ENCRYPT_DECRYPT
    And the key policy requires backend type HSM
    And the available backend is SOFTWARE
    When the client attempts to encrypt data with the key
    Then the KMS returns a policy denial error
    And the error message states "Operation not permitted: required backend HSM is not available"

  @functional-requirement @not-implemented
  Scenario: Policy requires approval
    Given a key exists with algorithm RSA_2048 and usage SIGN
    And the key policy requires approval for sign operations
    And no approval has been granted for the operation
    When the client attempts to sign a digest with the key
    Then the KMS returns a policy denial error
    And the error message states "Operation not permitted: approval required for SIGN operation"

  @functional-requirement @not-implemented
  Scenario: Policy-denied operation generates audit event
    Given a key exists with algorithm AES_256_GCM and usage ENCRYPT_DECRYPT
    And the key policy allows only SIGN operations
    When the client attempts to encrypt data with the key
    And the operation is denied by policy
    Then an audit event of type POLICY_DENIED_OPERATION is recorded
    And the audit event includes the KeyHandle and the denied operation
