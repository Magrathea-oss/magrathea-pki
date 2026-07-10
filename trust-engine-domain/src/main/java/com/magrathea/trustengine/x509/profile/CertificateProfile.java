package com.magrathea.trustengine.x509.profile;

public record CertificateProfile(int validityDays) {

    public String canonicalJson() {
        return "{\"validityDays\":" + validityDays + "}";
    }

    public String sha256DigestHex() {
        try {
            byte[] digest = java.security.MessageDigest.getInstance("SHA-256")
                    .digest(canonicalJson().getBytes(java.nio.charset.StandardCharsets.UTF_8));
            return java.util.HexFormat.of().formatHex(digest);
        } catch (java.security.NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 digest algorithm is not available", e);
        }
    }

    public CertificateProfileId profileId() {
        return CertificateProfileId.from("x509-profile-v1-sha256-" + sha256DigestHex());
    }

    public boolean hasProfileId(CertificateProfileId expectedProfileId) {
        return profileId().equals(expectedProfileId);
    }
}
