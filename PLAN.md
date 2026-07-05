# PLAN.md — Trust, PKI & Key Management Subsystem

## Obiettivo

Realizzare un sottosistema unico per:

- **PKI X.509**: CA interne, certificati TLS/mTLS, CRL/OCSP-ready, trust bundle.
- **PKI CVC**: Card Verifiable Certificates per scenari EAC/eID/smart-card-like.
- **SSH CA**: certificati SSH user/host, KRL, rotazione e trust distribution.
- **Key Management generico**: gestione chiavi per firma, cifratura, decrypt, wrap/unwrap, transit crypto e secret material, in stile operativo simile a HashiCorp Vault.
- **HSM/Token support**: PKCS#11 come interfaccia primaria, con Nitrokey HSM usato come backend di test.
- **TPM support**: uso del TPM 2.0 come secure element locale per chiavi, sealing, attestation, misurazioni BIOS/UEFI e binding a PCR.

L'obiettivo non è creare solo "una CA", ma un **trust and key management subsystem** capace di diventare il punto centrale per identità crittografiche, chiavi, certificati, attestazione macchina e distribuzione del trust.

---

## Principio guida

La PKI è solo una parte del problema.

Il componente deve essere progettato come:

```text
Trust & Key Management
├── X.509 PKI
├── CVC PKI
├── SSH CA
├── Generic Key Management
├── HSM Integration
├── TPM Platform Trust
└── Audit / Policy / Lifecycle
```

La logica deve rimanere nel dominio e nell'application layer.

Gli adapter devono occuparsi solo di:

- protocolli.
- storage concreto.
- integrazione HSM/TPM.
- API.
- CLI.
- admin panel.
- export/import.
- compatibilità con tool esterni.

---

## Nome modulo suggerito

Eviterei di chiamarlo solo `pki`, perché sarebbe riduttivo.

Possibili nomi:

```text
trust-engine
key-trust-engine
crypto-control-plane
trust-control-plane
identity-key-management
```

Nome consigliato:

```text
trust-engine
```

Motivo:

- include PKI, SSH CA, CVC, HSM, TPM e gestione chiavi.
- non lo vincola solo a X.509.
- lascia spazio a OIDC/Kerberos, mTLS, attestation e secret management.
- suona come componente infrastrutturale centrale, non come utility.

---

## Bounded context

```text
trust-engine-domain
trust-engine-application
trust-engine-infrastructure
trust-engine-api-adapter
trust-engine-admin-adapter
trust-engine-cli-adapter
trust-engine-test-support

trust-engine-x509
trust-engine-cvc
trust-engine-ssh
trust-engine-kms
trust-engine-hsm
trust-engine-tpm
```

### Dipendenze desiderate

```text
api/admin/cli adapters
        ↓
trust-engine-application
        ↓
trust-engine-domain

infrastructure adapters
        ↓
application ports
        ↓
domain
```

### Regola architetturale

Il dominio non deve dipendere direttamente da:

- Spring.
- filesystem.
- database.
- Bouncy Castle.
- OpenSSL.
- ssh-keygen.
- OpenSC.
- PKCS#11 concrete library.
- tpm2-tools.
- Vault.
- step-ca.
- cert-manager.
- Nitrokey-specific APIs.
- TPM software stack.

Il dominio deve conoscere concetti stabili:

```text
Key
KeyHandle
KeyUsage
KeyPolicy
CryptoOperation
TrustAnchor
CertificateAuthority
CertificateRequest
IssuedCredential
TrustBundle
RevocationRecord
PlatformIdentity
AttestationEvidence
AuditEvent
```

---

## Standard e riferimenti tecnici

Questi sono i riferimenti progettuali da usare come base, senza accoppiare il dominio alle implementazioni concrete:

| Area | Riferimento |
|---|---|
| X.509 PKI | RFC 5280 |
| SSH certificates | OpenSSH `PROTOCOL.certkeys` |
| SSH revocation | OpenSSH KRL |
| HSM / smart card | PKCS#11 / Cryptoki |
| CVC | BSI TR-03110 / ISO 7816 card-verifiable certificates |
| TPM | TCG TPM 2.0 Library Specification |
| TPM Linux integration | tpm2-tools / tpm2-tss / tpm2-pkcs11 |
| Nitrokey HSM test backend | Nitrokey HSM / SmartCard-HSM via PKCS#11 |

---

## Non-obiettivi iniziali

La prima versione non deve implementare tutto.

Fuori scope nella prima fase:

- CA pubblica browser-trusted.
- eIDAS qualified trust service.
- compliance completa WebTrust/ETSI.
- ACME completo.
- Vault clone completo.
- secret store generico completo con leasing dinamico.
- OCSP responder production-grade.
- CVC enterprise completo stile EJBCA.
- remote attestation fleet-wide già completa.
- gestione completa Secure Boot DB/KEK/PK.
- provisioning automatico firmware su ogni BIOS.
- HSM cluster enterprise.
- quorum/M-of-N completo già nella prima release.

Dentro scope da subito:

- modello astratto corretto.
- backend software di sviluppo.
- backend PKCS#11.
- test con Nitrokey.
- backend TPM2 locale.
- X.509 minimale.
- SSH CA minimale.
- key management generico minimale.
- CVC modellato fin dall'inizio, anche se implementato dopo X.509/SSH.
- audit append-only.
- policy centralizzate.
- lifecycle di chiavi e credenziali.

---

# Architettura logica

## Layer principali

```text
TrustEngineApiAdapter
TrustEngineAdminAdapter
TrustEngineCliAdapter
        ↓
TrustEngineApplication
        ↓
TrustEngineDomain
        ↓
Ports
        ↓
Infrastructure Adapters
        ├── SoftwareKeyStore
        ├── FilesystemMetadataStore
        ├── DatabaseMetadataStore
        ├── Pkcs11HsmProvider
        ├── NitrokeyHsmProvider
        ├── Tpm2Provider
        ├── OpenSshCertificateSigner
        ├── X509CertificateSigner
        └── CvcCertificateSigner
```

## Separazione fondamentale

```text
Certificate ≠ Key
KeyStore ≠ CertificateStore
HSM ≠ PKI
TPM ≠ HSM enterprise
SSH cert ≠ X.509 cert
CVC cert ≠ X.509 cert
Policy ≠ Backend
Identity ≠ Authorization
Attestation ≠ Authentication completa
```

Questo evita di far collassare tutto in una singola utility `CertificateService`.

---

# Dominio core

## Key

Rappresenta una chiave logica, non necessariamente esportabile.

```text
Key
- id
- alias
- algorithm
- size/curve
- type: SYMMETRIC | ASYMMETRIC | SECRET | HMAC | TPM_BOUND
- origin: GENERATED | IMPORTED | DERIVED | TPM_CREATED | HSM_CREATED
- backend: SOFTWARE | PKCS11 | TPM2 | EXTERNAL
- extractability: EXTRACTABLE | NON_EXTRACTABLE | WRAPPED_ONLY
- status: ACTIVE | DISABLED | DESTROYED | COMPROMISED | ROTATED
- usages
- policy id
- owner
- createdAt
- expiresAt
```

## KeyHandle

Il dominio non deve contenere materiale privato.

```text
KeyHandle
- key id
- backend id
- provider type
- object label
- object id
- slot/token reference
- public material reference
```

## KeyUsage

```text
SIGN
VERIFY
ENCRYPT
DECRYPT
WRAP
UNWRAP
DERIVE
MAC
RANDOM
ATTEST
SEAL
UNSEAL
CERTIFY
SSH_CA_SIGN
X509_CA_SIGN
CVC_CA_SIGN
```

## CryptoOperation

```text
SignCommand
VerifyCommand
EncryptCommand
DecryptCommand
WrapKeyCommand
UnwrapKeyCommand
GenerateKeyCommand
ImportKeyCommand
DestroyKeyCommand
RotateKeyCommand
SealSecretCommand
UnsealSecretCommand
QuotePlatformCommand
CertifyTpmKeyCommand
```

## IssuedCredential

Unifica certificati e credenziali firmate.

```text
IssuedCredential
- id
- type: X509_CERTIFICATE | CVC_CERTIFICATE | SSH_CERTIFICATE | TPM_ATTESTATION | TRUST_BUNDLE
- subject
- issuer
- public key reference
- serial/key id/cert id
- validity
- status
- policy id
- owner
- encoded material reference
```

---

# Area 1 — X.509 PKI

## Obiettivo

Gestire una PKI interna per:

- TLS/mTLS.
- API S3-compatible.
- admin panel.
- nodi storage.
- agent.
- service identity.
- future integrazioni OIDC/Kerberos.

## Entità X.509

```text
X509CertificateAuthority
- id
- name
- type: ROOT | INTERMEDIATE | EXTERNAL
- subject
- key id
- status
- path length
- basic constraints
- key usage
- validity
- parent id

X509CertificateRequest
- id
- csr
- subject
- SAN DNS/IP/URI/email
- requested usages
- requester
- policy id
- status

X509IssuedCertificate
- id
- serial
- subject
- SANs
- issuer
- validity
- fingerprint
- encoded certificate reference
- revocation status
```

## Profili iniziali

```text
INTERNAL_SERVICE_MTLS
S3_GATEWAY_TLS
ADMIN_PANEL_TLS
STORAGE_NODE_IDENTITY
OIDC_CLIENT_TLS
KERBEROS_BRIDGE_TLS
DEVELOPMENT_LOCALHOST
```

## Acceptance criteria

- Root CA e intermediate CA gestibili.
- Leaf certificate emessi solo da intermediate CA.
- Policy obbligatoria per ogni emissione.
- SAN validati da allowlist/pattern.
- CRL generabile.
- OCSP modellato, non obbligatorio in fase iniziale.
- Trust bundle versionati.
- Test con backend software e PKCS#11.

---

# Area 2 — CVC PKI

## Obiettivo

Supportare Card Verifiable Certificates, separati da X.509.

CVC non deve essere trattato come "X.509 compatto". Ha gerarchie, encoding, profili e semantica diversa.

## Entità CVC

```text
CvcCertificateAuthority
- id
- role: CVCA | DVCA | TERMINAL_CA
- country/authority reference
- holder reference
- key id
- algorithm profile
- status
- validity

CvcCertificateRequest
- id
- holder reference
- authority reference
- public key reference
- authorization template
- requested role
- policy id
- status

CvcIssuedCertificate
- id
- car: Certification Authority Reference
- chr: Certificate Holder Reference
- role
- authorization template
- effective date
- expiration date
- encoded CVC reference
```

## CVC roles

```text
CVCA
DVCA_DOMESTIC
DVCA_FOREIGN
INSPECTION_SYSTEM
AUTHENTICATION_TERMINAL
SIGNATURE_TERMINAL
CUSTOM_TERMINAL
```

## Note progettuali

- Il parser/encoder CVC deve essere isolato.
- Il dominio deve rappresentare campi CVC semanticamente, non solo come blob.
- Le policy CVC devono essere separate dalle policy X.509.
- La validità e la catena CVC vanno modellate secondo la logica CVC.
- CVC serve anche come test per verificare che il sistema non sia X.509-centrico.

## Acceptance criteria

- È possibile modellare una catena CVCA → DVCA → Terminal.
- È possibile importare/esportare un CVC encoded.
- È possibile generare una richiesta CVC.
- È possibile firmare CVC usando una chiave backend software o HSM.
- I test coprono:
  - encoding/decoding.
  - authority reference.
  - holder reference.
  - validità.
  - authorization template.
  - role mismatch.
  - algoritmo non consentito.

---

# Area 3 — SSH CA

## Obiettivo

Gestire certificati SSH user/host come primo cittadino del sistema.

## Entità SSH

```text
SshCertificateAuthority
- id
- name
- key id
- type: USER_CA | HOST_CA
- status
- principals policy
- validity policy

SshCertificateRequest
- id
- public key
- principals
- key id
- cert type: USER | HOST
- critical options
- extensions
- validity
- requester
- policy id

SshIssuedCertificate
- id
- serial
- key id
- principals
- cert type
- valid after
- valid before
- critical options
- extensions
- encoded certificate reference
- revocation status
```

## SSH use case

- firmare host key.
- firmare user key temporanee.
- emettere certificati short-lived.
- revocare con KRL.
- pubblicare CA pubblica user/host.
- distribuire `TrustedUserCAKeys`.
- distribuire `@cert-authority` known_hosts.

## Acceptance criteria

- User cert e host cert separati.
- Principals validati da policy.
- Validità breve di default.
- KRL generabile.
- SSH CA key può risiedere in HSM/TPM/software backend.
- Nessuna private key SSH deve essere esportata se backend non lo consente.
- Test end-to-end con `ssh-keygen` o adapter equivalente.

---

# Area 4 — Key Management generico

## Obiettivo

Gestire chiavi anche fuori dalla PKI.

Esempi:

- chiavi per firmare artifact.
- chiavi per cifrare configurazioni.
- chiavi per storage engine.
- chiavi per token interni.
- chiavi HMAC.
- chiavi di wrapping.
- chiavi per backup.
- chiavi per firma release.
- chiavi per sealing TPM.
- chiavi per autenticazione tra componenti.

## Funzioni minime

```text
CreateKey
ImportKey
GenerateDataKey
Encrypt
Decrypt
Sign
Verify
WrapKey
UnwrapKey
RotateKey
DisableKey
DestroyKey
ExportPublicKey
ExportWrappedKey
ListKeys
ReadKeyMetadata
```

## Vault-like transit engine

Modalità consigliata:

```text
application sends plaintext/ciphertext/signature request
        ↓
trust-engine performs crypto operation
        ↓
private key never leaves backend
```

Esempio:

```text
POST /kms/keys/{id}/sign
POST /kms/keys/{id}/verify
POST /kms/keys/{id}/encrypt
POST /kms/keys/{id}/decrypt
POST /kms/keys/{id}/wrap
POST /kms/keys/{id}/unwrap
```

## Policy chiavi

```text
KeyPolicy
- allowed operations
- allowed callers
- allowed algorithms
- extractability
- rotation period
- approval required
- max plaintext size
- audit level
- backend constraints
```

## Acceptance criteria

- Ogni operazione chiave passa da policy.
- Ogni operazione sensibile genera audit event.
- Chiavi non-esportabili restano non-esportabili.
- Il backend software permette sviluppo.
- Il backend PKCS#11 permette HSM.
- Il backend TPM permette sealing/signing locale.
- API generiche non dipendono da X.509.

---

# Area 5 — HSM support

## Obiettivo

Supportare HSM e token crittografici tramite PKCS#11.

Nitrokey HSM deve essere il backend di test iniziale, non un caso speciale nel dominio.

## Backend HSM

```text
Pkcs11Provider
- module path
- slot id / token label
- user pin provider
- so pin provider, solo provisioning
- object id strategy
- mechanism discovery
- session pool
- login strategy
- retry strategy
```

## Nitrokey test profile

```text
backend: PKCS11
provider: Nitrokey HSM / SmartCard-HSM
module: opensc-pkcs11.so oppure modulo specifico disponibile
slot: test token
mode: integration-test
```

## Operazioni HSM iniziali

- generate keypair.
- import certificate public object.
- sign digest/data.
- verify.
- enumerate objects.
- read public key.
- map object id → KeyHandle.
- test PIN failure.
- test token unavailable.
- test unsupported mechanism.

## Vincoli

- Non assumere che ogni HSM supporti ogni algoritmo.
- Fare mechanism discovery.
- Le policy devono poter richiedere "questa chiave deve stare in HSM".
- Il dominio non deve conoscere Nitrokey.
- Nitrokey deve essere un test profile di PKCS#11.

## Acceptance criteria

- Test integration con Nitrokey separati dai test unitari.
- Test unitari con fake PKCS#11 provider.
- Contract test per `CryptoProvider`.
- Chiave CA X.509 generabile su HSM.
- SSH CA key usabile da HSM se algoritmo/meccanismo lo consente.
- CVC signing usabile da HSM se algoritmo/meccanismo lo consente.
- Errore chiaro se il meccanismo non è supportato.

---

# Area 6 — TPM e BIOS/UEFI trust

## Obiettivo

Usare il TPM del sistema come componente di fiducia locale per:

- chiavi non esportabili legate alla macchina.
- sealing/unsealing di segreti.
- attestazione dello stato BIOS/UEFI/Secure Boot.
- misurazione PCR.
- quote firmate.
- enrollment di nodi.
- bootstrap di identità macchina.
- binding di configurazioni sensibili allo stato della piattaforma.

## Concetti TPM

```text
Endorsement Key, EK
- identità radicata nel TPM
- spesso accompagnata da EK certificate

Attestation Key, AK
- chiave usata per firmare quote/attestation
- certificabile rispetto all'EK

Platform Configuration Registers, PCR
- registri contenenti misure di firmware, bootloader, Secure Boot, kernel, initrd, ecc.

Quote
- firma TPM dei valori PCR selezionati

Sealed Secret
- segreto cifrato/rilasciabile solo se i PCR corrispondono a una policy

NV Index
- storage persistente nel TPM

Persistent Object
- chiave TPM persistente
```

## TPM use case

### 1. Enrollment macchina

```text
Generate AK
Read EK public/certificate
Create platform enrollment request
Verify EK/AK evidence
Register PlatformIdentity
Issue node identity certificate
Bind node to TPM key
```

### 2. Attestazione BIOS/UEFI

```text
Collect PCR values
Collect event log
Create TPM quote
Verify quote signature
Compare PCR profile
Evaluate Secure Boot / firmware policy
Mark platform as trusted/untrusted
```

### 3. Sealing di segreti

```text
Create secret
Define PCR policy
Seal secret to TPM
Store sealed blob
Unseal only if boot state matches
```

### 4. Chiavi macchina non esportabili

```text
Create TPM key
Use TPM key for signing/decryption
Expose as KeyHandle
Never export private material
```

### 5. TPM come PKCS#11 backend

Per compatibilità si può supportare anche:

```text
tpm2-pkcs11
```

Ma internamente conviene mantenere un provider TPM dedicato, perché TPM ha concetti che PKCS#11 non rappresenta bene:

- PCR.
- quote.
- sealing.
- attestation.
- EK/AK.
- NV indices.
- policy sessions.

## PCR policy iniziali

Definire policy esplicite:

```text
TPM_POLICY_NONE
- chiave/secret usabile senza vincolo PCR
- solo per sviluppo

TPM_POLICY_SECURE_BOOT
- richiede Secure Boot coerente
- PCR tipici da valutare in base alla piattaforma

TPM_POLICY_FIRMWARE_BOOT_CHAIN
- BIOS/UEFI + bootloader + kernel
- più restrittiva

TPM_POLICY_NODE_ENROLLMENT
- usata per bootstrap storage node

TPM_POLICY_CUSTOM
- configurata per esperimenti
```

## BIOS/UEFI caveat

Il TPM non "controlla" il BIOS.

Il TPM misura e protegge in base a ciò che viene registrato nei PCR.

Quindi il sistema deve distinguere:

```text
Secure Boot enabled
Measured Boot available
PCR values expected
Event log coherent
Quote valid
Firmware version allowed
```

Una quote valida non significa automaticamente che il BIOS sia sicuro; significa che la piattaforma ha prodotto misure verificabili rispetto a una baseline.

## Acceptance criteria

- È possibile creare una PlatformIdentity.
- È possibile generare AK.
- È possibile ottenere quote PCR.
- È possibile verificare quote.
- È possibile salvare baseline PCR.
- È possibile confrontare quote con baseline.
- È possibile sigillare un secret a una policy PCR.
- È possibile fallire l'unseal se PCR non corrisponde.
- È possibile usare TPM come key backend per signing.
- È possibile usare tpm2-pkcs11 come provider compatibile.
- I test distinguono:
  - TPM reale.
  - TPM simulator.
  - fake provider unitario.

---

# Area 7 — Policy engine

## Obiettivo

Unificare policy per:

- X.509 issuance.
- CVC issuance.
- SSH cert issuance.
- key usage.
- HSM requirements.
- TPM requirements.
- attestation requirements.
- exportability.
- rotation.
- revocation.
- approval workflow.

## Policy model

```text
TrustPolicy
- id
- name
- scope:
  - X509
  - CVC
  - SSH
  - KMS
  - HSM
  - TPM
- allowed subjects/principals
- allowed algorithms
- allowed usages
- max validity
- backend constraints
- approval requirements
- attestation requirements
- rotation settings
- audit level
```

## Esempi

### X.509 service policy

```yaml
id: x509-internal-service-mtls
scope: X509
allowedUsages:
  - serverAuth
  - clientAuth
allowedSanPatterns:
  dns:
    - "*.svc.internal"
    - "*.storage.internal"
  uri:
    - "spiffe://magrathea/*"
maxValidity: P30D
requiredBackend: HSM_OR_SOFTWARE
autoApproval: true
```

### SSH user cert policy

```yaml
id: ssh-admin-short-lived
scope: SSH
certType: USER
allowedPrincipalsFromRequester: true
maxValidity: PT8H
requiredExtensions:
  - permit-pty
approvalRequired: false
```

### TPM node enrollment policy

```yaml
id: tpm-node-enrollment
scope: TPM
requiresEkCertificate: true
requiresAkQuote: true
requiredPcrProfile: NODE_SECURE_BOOT
issueX509AfterAttestation: true
maxNodeCertificateValidity: P7D
```

### KMS signing key policy

```yaml
id: release-signing-key
scope: KMS
allowedOperations:
  - SIGN
  - VERIFY
requiredBackend: HSM
extractability: NON_EXTRACTABLE
approvalRequiredForSign: true
auditLevel: FULL
```

## Acceptance criteria

- Nessuna operazione sensibile bypassa policy.
- Deny motivato e auditato.
- Policy diverse per X.509/CVC/SSH/KMS/TPM.
- Policy testabili senza backend reali.
- Backend constraints rispettati.

---

# Area 8 — Storage e materiali sensibili

## Separazione storage

```text
MetadataStore
- CA metadata
- certificate metadata
- key metadata
- policy metadata
- audit metadata
- platform identity metadata

MaterialStore
- PEM/DER public material
- SSH public cert
- CVC encoded certificate
- CRL/KRL
- trust bundle

SecretStore
- encrypted secrets
- sealed blobs
- wrapped keys
- encrypted private keys solo se backend software

CryptoBackend
- software keystore
- HSM
- TPM
- external provider
```

## Regola

Il database può contenere metadati e materiale pubblico.

Il materiale privato deve essere:

- non esportabile, se in HSM/TPM.
- cifrato at-rest, se software.
- esportabile solo tramite policy esplicita.
- auditato in ogni operazione critica.

## Acceptance criteria

- Nessun log contiene materiale privato.
- Nessuna API restituisce chiavi private senza policy dedicata.
- KeyHandle è sufficiente per operare senza conoscere la chiave.
- Backup e restore distinguono:
  - metadata.
  - public material.
  - sealed/wrapped blobs.
  - HSM/TPM resident keys.

---

# Area 9 — API

## API X.509

```text
POST   /trust/x509/ca/root
POST   /trust/x509/ca/intermediate
GET    /trust/x509/ca/{id}
POST   /trust/x509/certificates/issue
POST   /trust/x509/certificates/renew
POST   /trust/x509/certificates/{id}/revoke
GET    /trust/x509/certificates/{id}
GET    /trust/x509/crl/{caId}
GET    /trust/x509/trust-bundles/{name}/active
```

## API CVC

```text
POST   /trust/cvc/ca
POST   /trust/cvc/requests
POST   /trust/cvc/certificates/issue
GET    /trust/cvc/certificates/{id}
GET    /trust/cvc/chains/{id}
POST   /trust/cvc/certificates/import
```

## API SSH

```text
POST   /trust/ssh/ca
POST   /trust/ssh/certificates/sign
POST   /trust/ssh/certificates/{id}/revoke
GET    /trust/ssh/ca/{id}/public-key
GET    /trust/ssh/krl/{caId}
```

## API KMS

```text
POST   /trust/kms/keys
POST   /trust/kms/keys/import
GET    /trust/kms/keys/{id}
POST   /trust/kms/keys/{id}/sign
POST   /trust/kms/keys/{id}/verify
POST   /trust/kms/keys/{id}/encrypt
POST   /trust/kms/keys/{id}/decrypt
POST   /trust/kms/keys/{id}/wrap
POST   /trust/kms/keys/{id}/unwrap
POST   /trust/kms/keys/{id}/rotate
POST   /trust/kms/keys/{id}/disable
DELETE /trust/kms/keys/{id}
```

## API TPM

```text
POST   /trust/tpm/platforms/enroll
POST   /trust/tpm/platforms/{id}/quote
POST   /trust/tpm/platforms/{id}/verify-quote
POST   /trust/tpm/platforms/{id}/seal
POST   /trust/tpm/platforms/{id}/unseal
GET    /trust/tpm/platforms/{id}
GET    /trust/tpm/platforms/{id}/pcr-baseline
POST   /trust/tpm/platforms/{id}/pcr-baseline
```

## Acceptance criteria

- API mutative auditabili.
- API read-only separate.
- Nessuna API parla direttamente con HSM/TPM bypassando application layer.
- Errori distinguono:
  - policy denied.
  - unsupported mechanism.
  - backend unavailable.
  - invalid request.
  - attestation failed.
  - crypto operation failed.

---

# Area 10 — CLI

## Obiettivo

Permettere uso anche senza admin panel.

```text
trustctl x509 ca create-root
trustctl x509 ca create-intermediate
trustctl x509 cert issue
trustctl x509 cert revoke
trustctl x509 bundle export

trustctl cvc ca create
trustctl cvc cert issue
trustctl cvc cert inspect

trustctl ssh ca create
trustctl ssh sign-user
trustctl ssh sign-host
trustctl ssh krl export

trustctl kms key create
trustctl kms sign
trustctl kms encrypt
trustctl kms decrypt
trustctl kms rotate

trustctl hsm slots
trustctl hsm mechanisms
trustctl hsm objects

trustctl tpm enroll
trustctl tpm quote
trustctl tpm verify-quote
trustctl tpm seal
trustctl tpm unseal
trustctl tpm pcr read
```

## Acceptance criteria

- CLI può usare profilo dev software.
- CLI può usare Nitrokey HSM.
- CLI può usare TPM locale.
- CLI produce output machine-readable JSON.
- CLI ha modalità human-readable.

---

# Area 11 — Audit

## Eventi minimi

```text
KEY_CREATED
KEY_IMPORTED
KEY_ROTATED
KEY_DISABLED
KEY_DESTROYED
KEY_USED_FOR_SIGN
KEY_USED_FOR_DECRYPT
KEY_WRAP_PERFORMED
KEY_UNWRAP_PERFORMED

X509_CA_CREATED
X509_CERTIFICATE_REQUESTED
X509_CERTIFICATE_ISSUED
X509_CERTIFICATE_REVOKED
X509_CRL_PUBLISHED
X509_TRUST_BUNDLE_PUBLISHED

CVC_CA_CREATED
CVC_CERTIFICATE_REQUESTED
CVC_CERTIFICATE_ISSUED
CVC_CERTIFICATE_IMPORTED

SSH_CA_CREATED
SSH_CERTIFICATE_ISSUED
SSH_CERTIFICATE_REVOKED
SSH_KRL_PUBLISHED

HSM_TOKEN_REGISTERED
HSM_KEY_CREATED
HSM_OPERATION_FAILED

TPM_PLATFORM_ENROLLED
TPM_QUOTE_CREATED
TPM_QUOTE_VERIFIED
TPM_ATTESTATION_FAILED
TPM_SECRET_SEALED
TPM_SECRET_UNSEALED

POLICY_CREATED
POLICY_CHANGED
POLICY_DENIED_OPERATION
```

## Campi minimi

```text
eventId
eventType
timestamp
actor
requesterIdentity
targetResource
policyId
backendId
result
reason
correlationId
```

## Regola

Gli eventi devono essere append-only.

Nessun evento deve contenere:

- private key.
- PIN HSM.
- secret plaintext.
- sealed secret plaintext.
- token password.
- TPM auth value.

---

# Area 12 — Test strategy

## Test domain

```text
KeyPolicyTest
KeyLifecycleTest
CryptoOperationAuthorizationTest
TrustBundleVersioningTest
X509PolicyTest
CvcPolicyTest
SshPolicyTest
TpmAttestationPolicyTest
RevocationPolicyTest
```

## Test application

```text
CreateKeyUseCaseTest
SignUseCaseTest
EncryptDecryptUseCaseTest
IssueX509CertificateUseCaseTest
IssueCvcCertificateUseCaseTest
IssueSshCertificateUseCaseTest
RevokeCredentialUseCaseTest
PublishTrustBundleUseCaseTest
EnrollTpmPlatformUseCaseTest
VerifyTpmQuoteUseCaseTest
SealUnsealSecretUseCaseTest
```

## Test infrastructure

```text
SoftwareKeyStoreTest
FilesystemMetadataStoreTest
Pkcs11ProviderContractTest
NitrokeyHsmIntegrationTest
Tpm2ProviderIntegrationTest
Tpm2Pkcs11CompatibilityTest
X509CertificateSignerTest
CvcEncoderDecoderTest
SshCertificateSignerTest
CrlPublisherTest
KrlPublisherTest
```

## Test hardware profiles

```text
unit
- fake providers
- no hardware

integration-software
- software keystore
- filesystem/database

integration-hsm-nitrokey
- Nitrokey HSM collegato
- PKCS#11 module configurato

integration-tpm-simulator
- swtpm o simulator
- tpm2-tools compatibile

integration-tpm-real
- TPM reale della macchina
- test non distruttivi
```

## Cucumber / BDD

```gherkin
Feature: X.509 service certificate issuance

  Scenario: Service receives a certificate for mTLS
    Given an active X.509 intermediate CA
    And a policy for internal service certificates
    When a service requests a certificate for "storage-1.svc.internal"
    Then the certificate is issued
    And the certificate contains serverAuth and clientAuth usages
    And an audit event is published
```

```gherkin
Feature: SSH host certificate issuance

  Scenario: Host receives a short-lived SSH certificate
    Given an active SSH host CA
    And a policy allowing host principals under "storage.internal"
    When a host requests a certificate for "node-1.storage.internal"
    Then the SSH host certificate is issued
    And the certificate expires within the configured validity window
    And the SSH CA private key is not exported
```

```gherkin
Feature: HSM-backed signing

  Scenario: A signing key remains inside Nitrokey HSM
    Given a PKCS#11 backend backed by Nitrokey HSM
    And a non-extractable signing key
    When the system signs a digest
    Then the signature is returned
    And the private key is never exported
    And an audit event records the signing operation
```

```gherkin
Feature: TPM sealed secret

  Scenario: Secret can be unsealed only with expected boot state
    Given a platform enrolled with TPM 2.0
    And a PCR baseline for secure boot
    When a secret is sealed to the PCR policy
    Then the secret can be unsealed only when the PCR quote matches the baseline
```

```gherkin
Feature: TPM platform attestation

  Scenario: Node is trusted after valid BIOS/UEFI measurement
    Given a platform with an enrolled Attestation Key
    And an approved PCR baseline
    When the platform submits a signed quote
    Then the quote is verified
    And the platform is marked as trusted for node certificate issuance
```

---

# Fase 0 — ADR e modello

## Obiettivo

Bloccare subito i confini del sistema.

## Deliverable

- ADR-001: `trust-engine` non è solo PKI.
- ADR-002: KeyHandle invece di private key nel dominio.
- ADR-003: PKCS#11 come backend HSM primario.
- ADR-004: TPM provider dedicato oltre a tpm2-pkcs11.
- ADR-005: X.509, CVC e SSH sono credential types separati.
- ADR-006: Audit append-only obbligatorio.
- ADR-007: Policy engine comune ma scope-specific.
- ADR-008: backend software solo dev/small deployment, non enterprise HSM replacement.

## Acceptance criteria

- Moduli creati.
- Dominio senza dipendenze runtime.
- Porte application definite.
- Nessun adapter può firmare direttamente.
- Test domain compilano.

---

# Fase 1 — KMS core minimale

## Obiettivo

Prima delle CA, implementare il nucleo chiavi.

## Scope

- Key metadata.
- KeyHandle.
- SoftwareKeyStore dev.
- CryptoProvider abstraction.
- generate keypair.
- sign/verify.
- encrypt/decrypt simmetrico.
- audit base.
- policy base.

## Acceptance criteria

- Chiave generabile.
- Operazione sign/verify funzionante.
- Operazione encrypt/decrypt funzionante.
- Private key non appare mai in log/API.
- Policy può bloccare operazione non autorizzata.
- Test unitari senza HSM/TPM.

---

# Fase 2 — PKCS#11 e Nitrokey HSM

## Obiettivo

Validare subito il modello su hardware reale.

## Scope

- Pkcs11Provider.
- slot/token discovery.
- mechanism discovery.
- login/logout/session.
- generate keypair.
- sign.
- public key export.
- object mapping.
- Nitrokey test profile.

## Acceptance criteria

- `trustctl hsm slots` mostra token.
- `trustctl hsm mechanisms` mostra meccanismi.
- Chiave generabile su Nitrokey.
- Firma eseguita da Nitrokey.
- KeyHandle persistito.
- Test hardware marcati separatamente.

---

# Fase 3 — X.509 minimale

## Obiettivo

Emettere certificati X.509 usando chiavi software o HSM.

## Scope

- root CA dev.
- intermediate CA.
- CSR signing.
- certificate profiles.
- trust bundle.
- CRL base.
- policy issuance.

## Acceptance criteria

- Root/intermediate funzionanti.
- Leaf cert emesso.
- CA key può stare in HSM.
- Trust bundle esportabile.
- CRL generabile.
- mTLS profile testato.

---

# Fase 4 — SSH CA

## Obiettivo

Gestire SSH user/host certificates.

## Scope

- SSH CA key.
- sign user key.
- sign host key.
- principals policy.
- validity short-lived.
- KRL.
- trust public key export.

## Acceptance criteria

- Certificato SSH user generabile.
- Certificato SSH host generabile.
- KRL generabile.
- Principals fuori policy rifiutati.
- CA key può stare in software/HSM/TPM se supportato.

---

# Fase 5 — TPM provider

## Obiettivo

Aggiungere TPM come backend e come sorgente di attestation.

## Scope

- TPM provider.
- TPM simulator support.
- TPM real support.
- create AK.
- read PCR.
- quote PCR.
- verify quote.
- seal/unseal.
- create signing key.
- tpm2-pkcs11 compatibility.

## Acceptance criteria

- PCR leggibili.
- Quote generabile.
- Quote verificabile.
- Secret sigillabile.
- Secret non sigillabile se PCR non corrisponde.
- KeyHandle TPM usabile per firma.
- Test real TPM non distruttivi.

---

# Fase 6 — TPM BIOS/UEFI attestation

## Obiettivo

Usare misure TPM per valutare lo stato BIOS/UEFI/boot chain.

## Scope

- PlatformIdentity.
- EK/AK enrollment.
- PCR baseline.
- event log ingestion.
- Secure Boot policy.
- firmware/boot profile.
- issue node certificate only after attestation.

## Acceptance criteria

- Piattaforma enrollata.
- Baseline PCR salvata.
- Quote confrontata con baseline.
- Attestation failure blocca emissione certificato nodo.
- Attestation success permette emissione certificato nodo.
- Audit completo.

---

# Fase 7 — CVC

## Obiettivo

Aggiungere CVC senza contaminare X.509.

## Scope

- CVC model.
- CVC parser/encoder.
- CVCA/DVCA/Terminal chain.
- CVC request.
- CVC signing.
- policy CVC.
- HSM-backed CVC signing dove supportato.

## Acceptance criteria

- Catena CVC modellabile.
- CVC generabile.
- CVC importabile.
- CVC validabile.
- Role mismatch rifiutato.
- Test encoding/decoding robusti.

---

# Fase 8 — Lifecycle completo

## Obiettivo

Gestire rotazione, revoca, disabilitazione e scadenze.

## Scope

- key rotation.
- cert rotation.
- trust bundle rollover.
- CRL/KRL publication.
- CA rollover.
- TPM platform re-enrollment.
- compromised key handling.

## Acceptance criteria

- Chiavi ruotabili.
- Certificati ruotabili.
- Trust bundle versionati.
- Revoca X.509 → CRL.
- Revoca SSH → KRL.
- CA compromised blocca nuove emissioni.
- Audit trail completo.

---

# Fase 9 — Admin panel

## Obiettivo

Aggiungere gestione visuale senza accoppiare UI e dominio.

## Funzioni minime

- lista chiavi.
- lista CA.
- lista certificati.
- lista SSH cert.
- lista CVC cert.
- backend status.
- HSM status.
- TPM platform status.
- certificati in scadenza.
- richieste in attesa.
- audit trail.
- policy viewer.
- trust bundle download.

## Acceptance criteria

- Nessuna azione UI bypassa application service.
- Operazioni critiche richiedono conferma.
- Azioni pericolose distinguibili.
- Nessun secret mostrato in UI.

---

# Fase 10 — Hardening

## Obiettivo

Preparare l'uso reale.

## Attività

- root CA offline.
- intermediate HSM-backed.
- PIN handling sicuro.
- HSM slot lifecycle.
- backup/restore metadata.
- HSM disaster recovery strategy.
- TPM re-enrollment.
- dual control per root/intermediate.
- approval workflow.
- alert scadenze.
- audit immutabile.
- secret zeroization.
- rate limiting crypto operation.
- policy change approval.
- test restore in ambiente pulito.

## Acceptance criteria

- Restore documentato e testato.
- Nessuna root key online in produzione, dove applicabile.
- Intermediate CA in HSM.
- TPM identity re-enrollment gestito.
- Chiavi compromesse revocabili/disabilitabili.
- Audit esportabile.
- Runbook operativo disponibile.

---

# Runbook iniziali

## Nitrokey HSM test

```bash
trustctl hsm slots
trustctl hsm mechanisms --slot <slot>
trustctl kms key create \
  --backend pkcs11 \
  --slot <slot> \
  --algorithm ec-p256 \
  --usage sign \
  --label test-signing-key

trustctl kms sign \
  --key test-signing-key \
  --input digest.bin
```

## TPM test

```bash
trustctl tpm pcr read
trustctl tpm enroll --name local-test-node
trustctl tpm quote --pcr 0,2,4,7
trustctl tpm verify-quote --platform local-test-node
trustctl tpm seal --policy secure-boot --input secret.txt
trustctl tpm unseal --sealed sealed.blob
```

## X.509 test

```bash
trustctl x509 ca create-root --profile dev
trustctl x509 ca create-intermediate --name internal-ca
trustctl x509 cert issue \
  --profile internal-service-mtls \
  --san dns:storage-1.svc.internal \
  --san uri:spiffe://magrathea/storage-1
```

## SSH test

```bash
trustctl ssh ca create --type host --backend pkcs11
trustctl ssh sign-host \
  --public-key /etc/ssh/ssh_host_ed25519_key.pub \
  --principal node-1.storage.internal \
  --validity 24h
```

---

# Rischi principali

## Rischio 1 — Scope troppo grande

Mitigazione:

- partire da KMS core + X.509 + PKCS#11.
- TPM come fase separata ma modellata subito.
- CVC modellato subito, implementato dopo.

## Rischio 2 — Confondere HSM e TPM

Mitigazione:

- HSM: backend crypto generico via PKCS#11.
- TPM: platform trust, sealing, attestation, PCR, AK/EK.
- tpm2-pkcs11 solo compatibility layer, non modello principale.

## Rischio 3 — X.509-centrismo

Mitigazione:

- `IssuedCredential` generico.
- moduli separati X.509/CVC/SSH.
- policy scope-specific.
- test CVC/SSH nel piano fin dall'inizio.

## Rischio 4 — Vault clone incompleto e pericoloso

Mitigazione:

- chiamarlo KMS/transit engine, non Vault replacement.
- implementare poche primitive solide.
- niente secret leasing dinamico all'inizio.
- audit e policy obbligatori.

## Rischio 5 — HSM mechanism mismatch

Mitigazione:

- mechanism discovery.
- capability model.
- test contract.
- errori espliciti.
- fallback solo se policy lo consente.

## Rischio 6 — TPM attestation interpretata male

Mitigazione:

- distinguere quote valida da piattaforma sicura.
- baseline esplicite.
- event log opzionale ma previsto.
- policy PCR documentate.
- secure boot non trattato come garanzia assoluta.

---

# Definition of Done generale

Una feature del trust-engine è completa solo se:

- ha modello dominio.
- ha application service.
- ha policy.
- ha audit.
- ha test unitario.
- ha test di integrazione dove serve.
- non espone materiale privato.
- non bypassa KeyHandle/CryptoProvider.
- produce errori espliciti.
- è documentata con runbook minimo.
- è compatibile con backend software.
- ha almeno un path verso HSM o TPM se riguarda chiavi sensibili.

---

# Roadmap sintetica

```text
Phase 0  — ADR + domain model
Phase 1  — KMS core software
Phase 2  — PKCS#11 + Nitrokey HSM
Phase 3  — X.509 PKI
Phase 4  — SSH CA
Phase 5  — TPM provider
Phase 6  — TPM BIOS/UEFI attestation
Phase 7  — CVC PKI
Phase 8  — Lifecycle/revocation/rotation
Phase 9  — Admin panel
Phase 10 — Hardening production
```

---

# Scelta progettuale consigliata

La soluzione più solida è trattare il progetto come **control plane crittografico**:

```text
trust-engine
  non è solo CA
  non è solo Vault
  non è solo HSM adapter
  non è solo TPM wrapper
```

È il punto in cui convergono:

- identità crittografica.
- chiavi.
- certificati.
- attestazione.
- policy.
- audit.
- trust distribution.

Questo permette di supportare X.509, CVC, SSH, HSM, Nitrokey, TPM e chiavi generiche senza forzare tutto dentro un modello PKI tradizionale.
