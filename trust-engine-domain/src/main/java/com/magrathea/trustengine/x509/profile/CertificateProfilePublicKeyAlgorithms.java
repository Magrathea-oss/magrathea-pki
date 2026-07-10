package com.magrathea.trustengine.x509.profile;

public class CertificateProfilePublicKeyAlgorithms {
    private final java.util.List<String> publicKeyAlgorithms;

    public CertificateProfilePublicKeyAlgorithms(java.util.Set arg0) {
        this.publicKeyAlgorithms = ((java.util.Set<?>) arg0).stream()
                .map(String.class::cast)
                .sorted()
                .toList();
    }

    public String canonicalJsonArray() {
        return publicKeyAlgorithms.stream()
                .collect(java.util.stream.Collectors.joining("\",\"", "[\"", "\"]"));
    }
}
