package com.magrathea.trustengine.x509.profile;

public record CertificateProfileId(String value) {
    public String algorithm() {
        return "sha256";
    }

    public String formatPrefix() {
        return "x509-profile-v1-sha256-";
    }

    public int digestHexLength() {
        return 64;
    }

    public int canonicalTextLength() {
        return formatPrefix().length() + digestHexLength();
    }

    public boolean hasFormatPrefix(String candidate) {
        return candidate.startsWith(formatPrefix());
    }

    public boolean hasCanonicalTextLength(String arg0) {
        return arg0.length() == canonicalTextLength();
    }

    public String digestText(String arg0) {
        return arg0.substring(formatPrefix().length());
    }

    public boolean hasDigestHexLength(String arg0) {
        return digestText(arg0).length() == digestHexLength();
    }

    public boolean hasLowercaseHexDigest(String arg0) {
        return digestText(arg0).matches("[0-9a-f]+");
    }

    public boolean isCanonicalText(String arg0) {
        if (arg0 == null) {
            return false;
        }
        return hasFormatPrefix(arg0)
                && hasCanonicalTextLength(arg0)
                && hasDigestHexLength(arg0)
                && hasLowercaseHexDigest(arg0);
    }

    public String canonicalText(String arg0) {
        return formatPrefix() + arg0;
    }

    public int digestStartIndex() {
        return formatPrefix().length();
    }

    public int digestEndIndex() {
        return canonicalTextLength();
    }

    public String value() {
        return value;
    }

    public static CertificateProfileId from(String arg0) {
        if (arg0 == null) {
            throw new IllegalArgumentException("invalid certificate profile id");
        }
        CertificateProfileId candidate = new CertificateProfileId(arg0);
        if (!candidate.hasFormatPrefix(arg0)) {
            throw new IllegalArgumentException("invalid certificate profile id");
        }
        if (!candidate.hasCanonicalTextLength(arg0)) {
            throw new IllegalArgumentException("invalid certificate profile id");
        }
        if (!candidate.hasLowercaseHexDigest(arg0)) {
            throw new IllegalArgumentException("invalid certificate profile id");
        }
        return candidate;
    }
}
