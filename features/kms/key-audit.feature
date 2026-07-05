Feature: KMS Audit Trail for Key Operations

  Business Need:
  As a KMS administrator
  I want a complete audit trail of all key-related operations
  So that key usage can be monitored, reviewed, and compliance can be demonstrated

  Rules:
  - Every key lifecycle operation generates an audit event with a specific event type
  - Audit events include the KeyHandle, operation type, timestamp, and identity
  - Audit events are append-only and cannot be modified or deleted after creation

  @functional-requirement @not-implemented
  Scenario: Key creation generates KEY_CREATED event
    Given the audit log is empty
    When a key is generated with algorithm EC_P256 and usage SIGN
    Then the audit log contains a KEY_CREATED event
    And the event includes the new KeyHandle
    And the event includes the algorithm and usage

  @functional-requirement @not-implemented
  Scenario: Key signing generates KEY_USED_FOR_SIGN event
    Given a key exists with algorithm EC_P256 and usage SIGN
    And the audit log contains the KEY_CREATED event for the key
    When the client signs a digest with the key
    Then the audit log contains a KEY_USED_FOR_SIGN event
    And the event includes the key's KeyHandle
    And the event includes the digest identifier

  @functional-requirement @not-implemented
  Scenario: Key destruction generates KEY_DESTROYED event
    Given a key exists with label "code-signing-key" and KeyHandle KH-001
    And the audit log contains the KEY_CREATED event for the key
    When the client destroys the key
    Then the audit log contains a KEY_DESTROYED event
    And the event includes the key's KeyHandle
    And the event timestamp is after the KEY_CREATED event timestamp

  @functional-requirement @not-implemented
  Scenario: Policy denial generates POLICY_DENIED_OPERATION event
    Given a key exists with algorithm AES_256_GCM and usage ENCRYPT_DECRYPT
    And the key policy allows only SIGN operations
    When the client attempts to encrypt data with the key
    And the operation is denied by policy
    Then the audit log contains a POLICY_DENIED_OPERATION event
    And the event includes the key's KeyHandle
    And the event includes the denied operation type "ENCRYPT"
    And the event includes the policy rule that was violated

  @functional-requirement @not-implemented
  Scenario: Audit events are append-only and immutable
    Given the audit log contains events for a key's lifecycle
    When an external actor attempts to delete or modify an existing audit event
    Then the KMS rejects the modification
    And the audit log content remains unchanged
    And an audit error is returned indicating immutability violation
