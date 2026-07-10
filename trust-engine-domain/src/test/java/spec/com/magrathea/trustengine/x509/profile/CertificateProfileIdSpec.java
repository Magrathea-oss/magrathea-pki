package spec.com.magrathea.trustengine.x509.profile;

import com.magrathea.trustengine.x509.profile.CertificateProfileId;

public class CertificateProfileIdSpec extends CertificateProfileIdSpecSupport {
    public void it_exposes_sha256_as_the_content_address_algorithm() {
        algorithm().shouldReturn("sha256");
    }

    public void it_exposes_the_x509_profile_v1_sha256_format_prefix() {
        formatPrefix().shouldReturn("x509-profile-v1-sha256-");
    }

    public void it_exposes_the_sha256_hex_digest_length() {
        digestHexLength().shouldReturn(64);
    }

    public void it_exposes_the_canonical_text_length() {
        canonicalTextLength().shouldReturn(87);
    }

    public void it_recognizes_a_candidate_with_the_format_prefix() {
        hasFormatPrefix("x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76").shouldReturn(true);
    }

    public void it_recognizes_the_canonical_text_length() {
        hasCanonicalTextLength("x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76").shouldReturn(true);
    }

    public void it_extracts_the_digest_text_after_the_format_prefix() {
        digestText("x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76").shouldReturn("6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76");
    }

    public void it_recognizes_the_digest_hex_length() {
        hasDigestHexLength("x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76").shouldReturn(true);
    }

    public void it_recognizes_a_lowercase_hex_digest() {
        hasLowercaseHexDigest("x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76").shouldReturn(true);
    }

    public void it_recognizes_canonical_text() {
        isCanonicalText("x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76").shouldReturn(true);
    }

    public void it_rejects_null_as_canonical_text() {
        isCanonicalText((String) null).shouldReturn(false);
    }

    public void it_builds_canonical_text_from_a_digest() {
        canonicalText("6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76").shouldReturn("x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76");
    }

    public void it_exposes_the_digest_start_index() {
        digestStartIndex().shouldReturn(23);
    }

    public void it_exposes_the_digest_end_index() {
        digestEndIndex().shouldReturn(87);
    }

    public void it_exposes_the_directly_constructed_canonical_value() {
        beConstructedWith("x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76");

        value().shouldReturn("x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76");
    }

    public void it_constructs_the_canonical_id_through_from() {
        beConstructedThrough("from", "x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76");

        value().shouldReturn("x509-profile-v1-sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76");
    }

    public void it_rejects_from_text_without_the_x509_profile_v1_sha256_prefix() {
        beConstructedThrough("from", "sha256-6f1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76");

        shouldThrow(IllegalArgumentException.class).duringInstantiation();
    }

    public void it_rejects_from_text_with_a_too_short_digest() {
        beConstructedThrough("from", "x509-profile-v1-sha256-6f1ed002");

        shouldThrow(IllegalArgumentException.class).duringInstantiation();
    }

    public void it_rejects_from_text_with_a_non_lowercase_hex_digest() {
        beConstructedThrough("from", "x509-profile-v1-sha256-gf1ed002ab5595859014ebf0951522d9b0214b864e3ae49b43c9d9f9b8a47f76");

        shouldThrow(IllegalArgumentException.class).duringInstantiation();
    }

    public void it_rejects_from_null_text() {
        beConstructedThrough("from", (String) null);

        shouldThrow(IllegalArgumentException.class).duringInstantiation();
    }

}
