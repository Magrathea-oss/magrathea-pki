package com.magrathea.trustengine.domain.kms;

public class Key {
    private final String id;
    private final Algorithm algorithm;
    private final KeyUsage usage;
    private final String label;

    public Key(Algorithm algorithm, KeyUsage usage, String label) {
        this.id = java.util.UUID.randomUUID().toString();
        this.algorithm = algorithm;
        this.usage = usage;
        this.label = label;
    }

    public Algorithm algorithm() {
        return algorithm;
    }

    public KeyUsage usage() {
        return usage;
    }

    public String label() {
        return label;
    }

    public String id() {
        return id;
    }
}
