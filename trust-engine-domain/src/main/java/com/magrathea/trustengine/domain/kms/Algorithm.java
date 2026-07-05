package com.magrathea.trustengine.domain.kms;

public enum Algorithm {
    EC_P256("secp256r1", 256);

    private final String curveName;
    private final int keySize;

    Algorithm(String curveName, int keySize) {
        this.curveName = curveName;
        this.keySize = keySize;
    }

    public String curveName() {
        return curveName;
    }

    public int keySize() {
        return keySize;
    }

}
