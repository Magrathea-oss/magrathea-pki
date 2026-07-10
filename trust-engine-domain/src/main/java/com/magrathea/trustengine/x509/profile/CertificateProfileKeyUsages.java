package com.magrathea.trustengine.x509.profile;

public class CertificateProfileKeyUsages {
    private final java.util.List<String> keyUsages;

    public CertificateProfileKeyUsages(java.util.Set arg0) {
        this.keyUsages = ((java.util.Set<?>) arg0).stream()
                .map(String.class::cast)
                .sorted()
                .toList();
    }

    public String canonicalJsonArray() {
        return keyUsages.stream()
                .collect(java.util.stream.Collectors.joining("\",\"", "[\"", "\"]"));
    }
}
