package com.magrathea.trustengine.apiadapter.x509;

import static org.junit.jupiter.api.Assertions.fail;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;

public class CertificateProfileIntegritySteps {
    private String manifestPath;
    private Map<String, String> approvedProfileEntry;
    private String profilePath;
    private Map<String, String> semanticProfileDefinition;
    private ProfileIntegrityVerificationResult verificationResult;

    @Given("the profile manifest {string} contains an approved profile entry:")
    public void theProfileManifestContainsAnApprovedProfileEntry(String manifestPath, DataTable table) {
        this.manifestPath = manifestPath;
        List<Map<String, String>> entries = table.asMaps(String.class, String.class);
        this.approvedProfileEntry = entries.isEmpty() ? Map.of() : entries.getFirst();
    }

    @Given("the YAML profile {string} does not contain its expected profile ID")
    public void theYamlProfileDoesNotContainItsExpectedProfileId(String profilePath) {
        this.profilePath = profilePath;
    }

    @Given("the YAML profile semantically defines a TLS server certificate profile with:")
    public void theYamlProfileSemanticallyDefinesATlsServerCertificateProfileWith(DataTable table) {
        this.semanticProfileDefinition = table.asMap(String.class, String.class);
    }

    @When("Magrathea verifies the profile for certificate issuance")
    public void magratheaVerifiesTheProfileForCertificateIssuance() {
        ProfileIntegrityVerificationRequest request = new ProfileIntegrityVerificationRequest(
                manifestPath,
                approvedProfileEntry,
                profilePath,
                semanticProfileDefinition);

        this.verificationResult = verifyProfileIntegrity(request);
    }

    @Then("the profile is parsed, schema validated, normalized, and converted to deterministic canonical JSON")
    public void theProfileIsParsedSchemaValidatedNormalizedAndConvertedToDeterministicCanonicalJson() {
        failWhenUseCaseHasNotProducedAResult();
    }

    @Then("the computed profile ID is {string}")
    public void theComputedProfileIdIs(String expectedProfileId) {
        failWhenUseCaseHasNotProducedAResult();
    }

    @Then("the profile is accepted as eligible for certificate issuance")
    public void theProfileIsAcceptedAsEligibleForCertificateIssuance() {
        failWhenUseCaseHasNotProducedAResult();
    }

    @Then("no PROFILE_INTEGRITY_FAILED audit event is recorded for {string}")
    public void noProfileIntegrityFailedAuditEventIsRecordedFor(String profilePath) {
        failWhenUseCaseHasNotProducedAResult();
    }

    private ProfileIntegrityVerificationResult verifyProfileIntegrity(ProfileIntegrityVerificationRequest request) {
        fail("UC-X509-PROFILE-INTEGRITY is not implemented: no application use case validates "
                + "an approved manifest profile ID against parsed, schema-validated, normalized, "
                + "canonical CertificateProfile content for certificate issuance yet. Request: "
                + request.summary());
        throw new IllegalStateException("unreachable");
    }

    private void failWhenUseCaseHasNotProducedAResult() {
        if (verificationResult == null) {
            fail("UC-X509-PROFILE-INTEGRITY did not produce a verification result because the use case is not implemented.");
        }
    }

    private record ProfileIntegrityVerificationRequest(
            String manifestPath,
            Map<String, String> approvedProfileEntry,
            String profilePath,
            Map<String, String> semanticProfileDefinition) {
        String summary() {
            return "manifestPath=" + manifestPath
                    + ", profilePath=" + profilePath
                    + ", expectedProfileId=" + approvedProfileEntry.get("expectedProfileId")
                    + ", semanticFields=" + semanticProfileDefinition.keySet();
        }
    }

    private record ProfileIntegrityVerificationResult() {
    }
}
