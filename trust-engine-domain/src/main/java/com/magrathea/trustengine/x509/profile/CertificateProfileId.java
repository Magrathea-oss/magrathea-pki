package com.magrathea.trustengine.x509.profile;

import java.util.regex.Pattern;

public record CertificateProfileId(String value) {
    private static final Pattern V1_GRAMMAR = Pattern.compile("x509-profile-v1-sha256-[0-9a-f]{64}");

    public CertificateProfileId {
        if (value == null || !V1_GRAMMAR.matcher(value).matches()) {
            throw new IllegalArgumentException("Certificate profile ID must match the complete v1 grammar");
        }
    }
}
