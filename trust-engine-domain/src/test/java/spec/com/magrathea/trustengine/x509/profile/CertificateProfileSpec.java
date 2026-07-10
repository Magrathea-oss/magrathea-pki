package spec.com.magrathea.trustengine.x509.profile;

import com.magrathea.trustengine.x509.profile.CertificateProfile;
import com.magrathea.trustengine.x509.profile.CertificateProfileId;

public class CertificateProfileSpec extends CertificateProfileSpecSupport {
    public void it_exposes_validity_days_from_the_semantic_profile_model() {
        beConstructedWith(397);

        validityDays().shouldReturn(397);
    }

    public void it_renders_canonical_json_for_validity_days() {
        beConstructedWith(397);

        canonicalJson().shouldReturn("{\"validityDays\":397}");
    }

    public void it_exposes_the_sha256_digest_hex_of_canonical_json() {
        beConstructedWith(397);

        sha256DigestHex().shouldReturn("fa0dfb6bc1f41bff05587eacab336c16a778eff23ec79b565d09a5023b48ac51");
    }

    public void it_builds_the_content_addressed_profile_id() {
        beConstructedWith(397);

        profileId().shouldReturn(CertificateProfileId.from("x509-profile-v1-sha256-fa0dfb6bc1f41bff05587eacab336c16a778eff23ec79b565d09a5023b48ac51"));
    }

    public void it_recognizes_a_matching_expected_profile_id() {
        beConstructedWith(397);

        hasProfileId((CertificateProfileId) CertificateProfileId.from("x509-profile-v1-sha256-fa0dfb6bc1f41bff05587eacab336c16a778eff23ec79b565d09a5023b48ac51")).shouldReturn(true);
    }
}
