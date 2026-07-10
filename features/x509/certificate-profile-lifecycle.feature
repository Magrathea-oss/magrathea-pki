@x509 @certificate-profile @lifecycle @governance @event-envelope @adr-0002 @not-implemented @uc-x509-profile
Feature: Governed X.509 certificate profile lifecycle events

  Business Need:
  As a Registration Authority Operator
  I want certificate profile lifecycle changes to be captured as structured event envelopes
  So that profile governance has an executable contract before any persistence or projection technology is introduced

  Rules:
  - Certificate profile lifecycle governance belongs to `UC-X509-PROFILE`
  - This requirement defines only the structured event envelope for a profile lifecycle change
  - Persistence, stream layout, compare-and-swap writes, signed commits, publication, projectors, read models, replay, and runtime support are outside this requirement
  - Lifecycle event envelopes never contain secrets in metadata or payload

  @functional-requirement @not-implemented @req-x509-profile-lifecycle-001
  Scenario: Register a certificate profile lifecycle change as a structured event envelope
    Given a Registration Authority Operator "ra-operator@example.test" is registering the lifecycle of certificate profile aggregate "x509-profile/tls-server-baseline"
    And the lifecycle change has these envelope inputs:
      | aggregateId      | x509-profile/tls-server-baseline          |
      | aggregateVersion | 1                                         |
      | eventType        | CERTIFICATE_PROFILE_REGISTERED            |
      | actor            | ra-operator@example.test                  |
      | causationId      | cmd-register-profile-2026-0001            |
      | correlationId    | profile-onboarding-2026-0001              |
      | schemaVersion    | certificate-profile-lifecycle-event.v1    |
    And the lifecycle change payload is:
      | profileId      | x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76 |
      | profilePath    | profiles/x509/tls-server-baseline.yaml                                               |
      | lifecycleState | draft                                                                                 |
      | reason         | Initial registration for TLS server certificate issuance policy                        |
    When Magrathea records the certificate profile lifecycle change as an event envelope
    Then the event envelope contains these fields:
      | field            | expected value or constraint                                                          |
      | eventId          | a non-empty unique event identifier                                                    |
      | aggregateId      | x509-profile/tls-server-baseline                                                       |
      | aggregateVersion | 1                                                                                      |
      | eventType        | CERTIFICATE_PROFILE_REGISTERED                                                         |
      | occurredAt       | an ISO-8601 UTC timestamp for when the lifecycle event occurred                         |
      | actor            | ra-operator@example.test                                                               |
      | causationId      | cmd-register-profile-2026-0001                                                         |
      | correlationId    | profile-onboarding-2026-0001                                                           |
      | schemaVersion    | certificate-profile-lifecycle-event.v1                                                 |
      | payload          | the structured lifecycle change payload supplied for the certificate profile aggregate  |
    And the payload includes the profile identifier, profile path, lifecycle state, and reason from the lifecycle change
    And no envelope field is omitted, empty, or represented only as unstructured text
    And the envelope does not assert persistence, stream placement, publication, projection, read-model availability, replay support, or runtime Git integration
