package com.magrathea.trustengine.x509.profile;

import java.util.Optional;

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

    public static Optional<PublicKeyAlgorithm> findByWireToken(String wireToken) {
        for (PublicKeyAlgorithm algorithm : values()) {
            if (algorithm.wireToken.equals(wireToken)) {
                return Optional.of(algorithm);
            }
        }
        return Optional.empty();
    }
}
