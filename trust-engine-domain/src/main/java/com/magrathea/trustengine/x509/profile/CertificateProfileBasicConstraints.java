package com.magrathea.trustengine.x509.profile;

public record CertificateProfileBasicConstraints(boolean ca) {
    public String canonicalJsonObject() {
        return "{\"ca\":" + ca + "}";
    }
}
