package com.magrathea.trustengine.x509.profile;

import java.util.Optional;

public enum SubjectPublicKeyProfile {
    EC_P256("EC_P256"),
    RSA_3072("RSA_3072");

    private final String wireToken;

    private SubjectPublicKeyProfile(String wireToken) {
        this.wireToken = wireToken;
    }

    public String wireToken() {
        return wireToken;
    }

    public static Optional<SubjectPublicKeyProfile> findByWireToken(String wireToken) {
        for (SubjectPublicKeyProfile algorithm : values()) {
            if (algorithm.wireToken.equals(wireToken)) {
                return Optional.of(algorithm);
            }
        }
        return Optional.empty();
    }
}
