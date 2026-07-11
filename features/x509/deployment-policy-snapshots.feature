@x509 @deployment-policy @yaml @governance @adr-0004 @uc-x509-deployment-policy
Feature: Governed YAML deployment-policy snapshots

  Ability:
  As a PKI deployment operator
  I want immutable declarative policy snapshots to govern algorithm eligibility
  So that every decision is deterministic, fail-closed, reproducible from identified inputs, and independent of CertificateProfile v1 identity

  Rules:
  - YAML policy is strictly admitted declarative data and cannot define algorithms or executable behavior
  - A policy selects exact known wire tokens from the separate compiled algorithm taxonomies
  - Policy rules invoke only stable validator IDs from a compatible version of the compiled validator catalog and supply parameters from each validator's closed typed schema
  - Evaluation receives an explicit instant and locally available immutable evidence; it has no implicit clock or network access
  - Missing, expired, revoked, incompatible, ambiguous, unverifiable, or inapplicable policy or evidence fails closed
  - Every decision and its audit evidence bind the immutable profile, policy, evidence, evaluator, and validator-catalog identities used
  - Policy snapshots and policy decision data remain outside CertificateProfile v1 canonical content
  - Reload stages and validates a complete candidate set before one atomic swap, and governed publication state cannot move backwards
  - These requirements make no WebPKI, eIDAS, ETSI, FIPS, Common Criteria, or other certification or conformance claim

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-deployment-policy-001
  Scenario: Admit only closed algorithm selections and compiled validator invocations
    Given a YAML deployment-policy candidate declares a supported policy schema version
    And every algorithm selection is an exact known wire token in its declared taxonomy
    And every rule names a stable compiled validator ID from a compatible declared catalog version
    And every rule parameter has the name, native YAML type, and value bounds required by that validator's closed parameter schema
    When Magrathea strictly admits the policy candidate
    Then the admitted policy is immutable declarative data
    And its algorithm selections retain their exact case-sensitive wire tokens
    And its rules retain their validator IDs, catalog version requirements, and typed parameters
    And the YAML defines neither a new algorithm nor new validator semantics

  @functional-requirement @not-implemented @req-x509-deployment-policy-002
  Scenario Outline: Reject an unknown or miscased algorithm token at policy admission
    Given a YAML deployment-policy candidate selects "<token>" for the "<taxonomy>" taxonomy
    And that complete case-sensitive token is not in the compiled vocabulary for the declared taxonomy
    When Magrathea strictly admits the policy candidate
    Then admission is rejected with a stable unknown-algorithm-token reason
    And no policy snapshot is staged or activated

    Examples:
      | taxonomy                       | token       |
      | X.509 subject public-key profile | ec_p256     |
      | X.509 subject public-key profile | RSA_4096    |
      | X.509 issuer signature suite   | EC_P256     |

  @functional-requirement @not-implemented @req-x509-deployment-policy-003
  Scenario Outline: Reject a validator invocation that is not provably compatible
    Given a YAML deployment-policy candidate contains validator invocation "<invocation>"
    When Magrathea checks it against the running compiled validator catalog
    Then policy admission is rejected with a stable validator-compatibility reason
    And no validator is selected by fallback, name similarity, or silent version substitution
    And no policy snapshot is staged or activated

    Examples:
      | invocation                                                   |
      | an unknown validator ID                                      |
      | a known validator ID from an unsupported catalog version     |
      | a known validator ID with an unknown parameter               |
      | a known validator ID with a wrongly typed parameter          |
      | a known validator ID with a parameter outside declared bounds |

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-deployment-policy-004
  Scenario Outline: Reject executable or open-ended content in policy YAML
    Given a YAML deployment-policy candidate contains "<forbiddenContent>"
    When Magrathea strictly admits the policy candidate
    Then admission is rejected because policy YAML is declarative data only
    And the content is not compiled, interpreted, reflected upon, fetched, or executed
    And no policy snapshot is staged or activated

    Examples:
      | forbiddenContent         |
      | an arbitrary expression  |
      | a script                 |
      | a regular expression     |
      | a reflection target      |
      | a dynamic class name     |
      | a dynamic method name    |
      | a network reference to evaluate |

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-deployment-policy-005
  Scenario: Evaluate a policy decision at the caller-supplied instant
    Given an admitted applicable deployment-policy snapshot and its required immutable evidence snapshots are locally available
    And the caller supplies the evaluation instant "2026-07-11T16:00:00Z"
    When Magrathea evaluates the governed operation
    Then every effective interval, transition horizon, and evidence-freshness rule is evaluated at "2026-07-11T16:00:00Z"
    And no validator reads an implicit wall clock
    And policy evaluation performs no network access

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-deployment-policy-006
  Scenario Outline: Fail closed when required policy or evidence cannot govern the operation
    Given a governed operation requires deployment-policy evaluation at an explicit instant
    And its required "<inputKind>" is "<condition>"
    When Magrathea evaluates the operation
    Then the result is deny with a stable reason identifying the failed condition
    And the governed operation is not authorized

    Examples:
      | inputKind | condition      |
      | policy    | missing        |
      | policy    | expired        |
      | policy    | revoked        |
      | policy    | inapplicable   |
      | policy    | incompatible   |
      | evidence  | missing        |
      | evidence  | expired        |
      | evidence  | revoked        |
      | evidence  | inapplicable   |
      | evidence  | unverifiable   |

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-deployment-policy-007
  Scenario: Bind a deployment decision to immutable inputs and compiled semantics
    Given a governed operation identifies a CertificateProfile, an admitted policy snapshot, and every required evidence snapshot by immutable ID
    And the evaluator version and validator-catalog version are fixed for the evaluation
    And the caller supplies an explicit evaluation instant
    When Magrathea produces the policy decision
    Then the decision uses the immutable policy snapshot ID rather than a mutable policy alias
    And its audit evidence binds the CertificateProfile ID, policy snapshot ID, all evidence snapshot IDs, evaluator version, validator-catalog version, and explicit evaluation instant
    And its audit evidence records the result and stable reason and rule identifiers
    And the decision does not assert certification or general standards conformance

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-deployment-policy-008
  Scenario: Keep deployment policy outside CertificateProfile v1 identity
    Given the normative CertificateProfile v1 golden fixture has profile ID "x509-profile-v1-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee"
    And two governed evaluations select different immutable policy or evidence snapshot IDs for that same profile
    When the CertificateProfile v1 identity is formed for each evaluation
    Then neither policy data, policy snapshot IDs, evidence snapshot IDs, evaluator versions, nor deployment permissions are inserted into CertificateProfile v1 canonical content
    And both evaluations retain the approved CertificateProfile v1 golden bytes
    And both CertificateProfile IDs remain "x509-profile-v1-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee"
    And each decision separately binds the policy snapshot ID used

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-deployment-policy-009
  Scenario: Atomically activate a fully validated candidate policy set
    Given one complete immutable policy and evidence set is active
    And a newer complete candidate set has been staged without changing the active set
    When all approved candidate checks succeed, including strict admission, referenced content, publication authorization, trust verification, catalog compatibility, typed parameters, evidence applicability, rollback state, and deterministic preflight
    Then the complete candidate set replaces the active set in one atomic swap
    And no decision can observe a mixture of the prior and candidate sets

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-deployment-policy-010
  Scenario Outline: Retain the prior known-good set when reload validation fails
    Given one complete immutable policy and evidence set is active
    And a candidate set fails "<candidateCheck>"
    When Magrathea attempts to reload the candidate set
    Then the candidate set is rejected
    And the prior known-good set remains active and unchanged
    And no candidate artifact is partially activated
    And the rejection is recorded with a stable reason

    Examples:
      | candidateCheck             |
      | strict schema admission    |
      | referenced content check   |
      | publication authorization  |
      | trust verification         |
      | catalog compatibility      |
      | typed parameter validation |
      | evidence applicability     |
      | deterministic preflight    |

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-deployment-policy-011
  Scenario: Reject rollback of governed publication state
    Given a policy namespace has a recorded highest accepted governed publication state
    And a candidate publication is older, revoked, expired, or conflicts with that state
    When Magrathea validates the candidate for activation
    Then activation is rejected with a stable rollback-protection reason
    And the active policy and evidence set remains unchanged
    And a content hash or Git history alone is not accepted as proof of freshness

  @functional-requirement @non-functional-requirement @not-implemented @req-x509-deployment-policy-012
  Scenario Outline: Reject ambiguous or unsupported YAML before policy admission
    Given a deployment-policy candidate uses "<yamlConstruct>"
    When Magrathea strictly admits the YAML document
    Then admission is rejected before a semantic policy snapshot is formed
    And no default, coercion, deduplication, merge, or document selection hides the rejected input
    And no policy snapshot is staged or activated

    Examples:
      | yamlConstruct                 |
      | an unknown schema member      |
      | a duplicate mapping key       |
      | an alias or anchor            |
      | a merge key                   |
      | a custom tag                  |
      | multiple YAML documents       |
      | an explicit null where disallowed |
      | scalar coercion               |
      | a duplicate set member        |
      | invalid Unicode               |

  @non-functional-requirement @placeholder @req-x509-deployment-policy-013
  Scenario: Define the deployment-policy schema and canonical snapshot identity
    Given the policy schema namespace, canonicalization algorithm, digest namespace, identifier grammar, and golden fixtures are not yet approved
    When the deployment-policy identity contract is approved
    Then executable examples must fix each identity-affecting rule and its golden canonical bytes and snapshot ID before implementation

  @non-functional-requirement @placeholder @req-x509-deployment-policy-014
  Scenario: Define signed publication and trusted distribution
    Given signing algorithms, publication roles, trust-anchor custody, rotation, revocation, and environment-specific distribution are not yet approved
    When the publication trust model is approved
    Then executable requirements must define signature verification and trusted distribution behavior before activation support is implemented

  @functional-requirement @non-functional-requirement @placeholder @req-x509-deployment-policy-015
  Scenario: Define monotonic state recovery and authorized break-glass rollback
    Given the monotonic rollback mechanism, disaster-recovery procedure, and break-glass authorization evidence are not yet approved
    When those governance decisions are approved
    Then executable requirements must define normal recovery and separately authenticated and audited break-glass behavior before either path is implemented

  @functional-requirement @non-functional-requirement @placeholder @req-x509-deployment-policy-016
  Scenario: Define profile-specific evidence and validator semantics
    Given evidence schemas, issuers, freshness and revocation rules, retention, catalog compatibility rules, and named deployment-policy editions are not yet approved
    When a deployment profile is approved for implementation
    Then executable requirements must define its edition-scoped evidence and compiled-validator behavior without claiming broader certification or conformance
