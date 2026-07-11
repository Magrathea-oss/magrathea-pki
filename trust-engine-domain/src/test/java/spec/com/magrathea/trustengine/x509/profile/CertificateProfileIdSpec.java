package spec.com.magrathea.trustengine.x509.profile;

import com.magrathea.trustengine.x509.profile.CertificateProfileId;

public class CertificateProfileIdSpec extends CertificateProfileIdSpecSupport {
    public void it_preserves_the_complete_canonical_profile_identifier() {
        String canonicalValue = "x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76";

        shouldBeARecord();
        beConstructedWith(canonicalValue);

        value().shouldReturn(canonicalValue);
    }

    public void it_rejects_a_profile_identifier_with_leading_whitespace() {
        String malformedValue = " x509-profile-v1-sha256-d40ed2a8c1f61164e3f540e7623608c9a8797a7ad1a657d4dffbb661cd1999ee";

        beConstructedWith(malformedValue);

        shouldThrow(IllegalArgumentException.class).duringInstantiation();
    }

    public void it_rejects_a_null_profile_identifier() {
        beConstructedWith((String) null);

        shouldThrow(IllegalArgumentException.class).duringInstantiation();
    }
}
