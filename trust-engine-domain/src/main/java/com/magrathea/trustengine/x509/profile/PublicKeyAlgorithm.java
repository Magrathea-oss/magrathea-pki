package com.magrathea.trustengine.x509.profile;

public enum PublicKeyAlgorithm {
    EC_P256("EC_P256"),
    RSA_3072("RSA_3072");

    private final String wireToken;

    private PublicKeyAlgorithm(String wireToken) {
        this.wireToken = wireToken;
    }

    public String wireToken() {
        return wireToken;
    }
}
