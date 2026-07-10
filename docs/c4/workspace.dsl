workspace "Magrathea PKI - Trust Engine" "Designed C4 architecture for the Magrathea PKI product and its trust-engine bounded contexts." {

  model {
    // People shown at C1/C2 level. Detailed permissions are intentionally outside this diagram.
    consumer = person "PKI Consumer" "Application or service that consumes PKI capabilities for certificates, signatures, encryption, key custody, or attestation."
    raOperator = person "Registration Authority Operator" "Validates certificate requests and registration evidence before issuance."
    caOperator = person "Certificate Authority Operator" "Operates CA lifecycle, issuance policies, revocation, and protocol-specific CA administration."
    complianceOfficer = person "Compliance Officer" "Reviews policy conformance, audit evidence, and regulated operation of the PKI product."

    magrathea = softwareSystem "Magrathea PKI" "Product-owned PKI trust engine. Roadmap: X.509 first, then CVC, then SSH; KMS features/scaffold exist first." {
      // C2 containers are deployable or intentionally extractable bounded contexts.
      // They are not Maven modules, JARs, WARs, Docker images, or shared kernels.
      // Target service technology is Java 21, Spring Boot 4 LTS, and Spring Reactive/WebFlux.

      x509Ca = container "X.509 CA" "Roadmap phase 1 bounded context for X.509 certificate issuance, CA hierarchy, revocation, and lifecycle operations." "Java 21, Spring Boot 4 LTS, Spring Reactive/WebFlux (target)"

      cvcCa = container "CVC CA" "Roadmap phase 2 bounded context for Card Verifiable Certificate issuance and lifecycle operations." "Java 21, Spring Boot 4 LTS, Spring Reactive/WebFlux (target)"

      sshCa = container "SSH CA" "Roadmap phase 3 bounded context for SSH certificate issuance and lifecycle operations." "Java 21, Spring Boot 4 LTS, Spring Reactive/WebFlux (target)"

      kms = container "KMS" "Bounded context for key lifecycle, signing, encryption, policy enforcement, audit, and custody backend selection. Current feature/scaffold focus." "Java 21, Spring Boot 4 LTS, Spring Reactive/WebFlux (target)" {
        keyService = component "Key Service" "Coordinates key generation, import, destruction, and lifecycle transitions."
        signingService = component "Signing Service" "Coordinates digest signing and signature verification with asymmetric keys."
        encryptionService = component "Encryption Service" "Coordinates plaintext encryption and ciphertext decryption with symmetric keys."
        policyService = component "Policy Service" "Evaluates allowed usages, custody backend constraints, approvals, and key operation policy."
        auditService = component "Audit Service" "Records append-only audit evidence for key operations and administrative decisions."
        keyRepository = component "Key Repository" "Persists key metadata, lifecycle state, custody references, and audit lookup data."
      }

      hsmKeyCustody = container "HSM Key Custody" "Bounded context for product-owned or product-managed HSM-backed key custody and cryptographic operation delegation. Physical HSM placement belongs to the Deployment View." "Java 21, Spring Boot 4 LTS, Spring Reactive/WebFlux (target)"

      tpmAttestation = container "TPM Attestation" "Bounded context for product-owned or product-managed TPM-backed identity, attestation, and key sealing profiles. Physical TPM placement belongs to the Deployment View." "Java 21, Spring Boot 4 LTS, Spring Reactive/WebFlux (target)"
    }

    // C3 relationships for KMS are defined at the most specific currently modeled level.
    consumer -> keyService "generates, imports, destroys, and queries keys" "HTTPS"
    consumer -> signingService "requests signatures and verifies signatures" "HTTPS"
    consumer -> encryptionService "encrypts plaintext and decrypts ciphertext" "HTTPS"
    caOperator -> policyService "configures key usage and custody policies" "CLI/HTTPS"
    complianceOfficer -> auditService "reviews key operation audit evidence" "CLI/HTTPS"

    keyService -> policyService "checks lifecycle and custody policy"
    signingService -> policyService "checks signing policy"
    encryptionService -> policyService "checks encryption policy"
    keyService -> keyRepository "stores and loads key state and custody references"
    signingService -> keyRepository "loads signing key references"
    encryptionService -> keyRepository "loads encryption key references"

    // C2 relationships for bounded contexts without component detail yet.
    raOperator -> x509Ca "submits and validates X.509 registration evidence" "HTTPS"
    caOperator -> x509Ca "operates X.509 CA lifecycle, issuance, and revocation" "CLI/HTTPS"
    caOperator -> cvcCa "operates CVC CA lifecycle and issuance" "CLI/HTTPS"
    caOperator -> sshCa "operates SSH CA lifecycle and issuance" "CLI/HTTPS"
    complianceOfficer -> x509Ca "reviews certificate lifecycle audit evidence" "CLI/HTTPS"
    complianceOfficer -> cvcCa "reviews CVC lifecycle audit evidence" "CLI/HTTPS"
    complianceOfficer -> sshCa "reviews SSH lifecycle audit evidence" "CLI/HTTPS"

    x509Ca -> kms "uses issuer key references and signing operations" "Internal API"
    cvcCa -> kms "uses issuer key references and signing operations" "Internal API"
    sshCa -> kms "uses issuer key references and signing operations" "Internal API"
    kms -> hsmKeyCustody "delegates HSM-backed key custody and cryptographic operations" "Internal ports/adapters"
    x509Ca -> tpmAttestation "uses hardware-backed attestation evidence when policy requires it" "Internal API"
    cvcCa -> tpmAttestation "uses hardware-backed attestation evidence when policy requires it" "Internal API"
    sshCa -> tpmAttestation "uses hardware-backed attestation evidence when policy requires it" "Internal API"
  }

  views {
    systemContext magrathea "SystemContext" "C1 System Context for Magrathea PKI." {
      include *
      autoLayout lr
    }

    container magrathea "Containers" "C2 Container view: deployable or intentionally extractable bounded contexts, not build or deployment artifacts." {
      include *
      autoLayout lr
    }

    component kms "KmsComponents" "C3 Component view for the KMS bounded context. Other bounded contexts do not have C3 views until their design and implementation slices exist." {
      include *
      autoLayout lr
    }

    styles {
      element "Person" {
        shape person
      }
    }
  }
}
