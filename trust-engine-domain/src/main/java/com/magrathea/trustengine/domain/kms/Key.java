package com.magrathea.trustengine.domain.kms;

import java.util.UUID;

public class Key {
    private final Algorithm algorithm;
    private final KeyUsage usage;
    private final String label;
    private final String id;

    public Key(Algorithm algorithm, KeyUsage usage, String label) {
        this.algorithm = algorithm;
        this.usage = usage;
        this.label = label;
        this.id = UUID.randomUUID().toString();
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
