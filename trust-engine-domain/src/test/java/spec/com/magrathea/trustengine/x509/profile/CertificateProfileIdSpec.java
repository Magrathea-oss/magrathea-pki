package spec.com.magrathea.trustengine.x509.profile;

import com.magrathea.trustengine.x509.profile.CertificateProfileId;

public class CertificateProfileIdSpec extends CertificateProfileIdSpecSupport {
    public void it_preserves_the_complete_canonical_profile_identifier() {
        String canonicalValue = "x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76";

        shouldBeARecord();
        beConstructedWith(canonicalValue);

        value().shouldReturn(canonicalValue);
    }
}
