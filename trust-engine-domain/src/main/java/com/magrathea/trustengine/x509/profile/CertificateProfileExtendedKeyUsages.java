package com.magrathea.trustengine.x509.profile;

public class CertificateProfileExtendedKeyUsages {
    private final java.util.List<String> extendedKeyUsages;

    public CertificateProfileExtendedKeyUsages(java.util.Set arg0) {
        this.extendedKeyUsages = ((java.util.Set<?>) arg0).stream()
                .map(String.class::cast)
                .sorted()
                .toList();
    }

    public String canonicalJsonArray() {
        return extendedKeyUsages.stream()
                .collect(java.util.stream.Collectors.joining("\",\"", "[\"", "\"]"));
    }
}
