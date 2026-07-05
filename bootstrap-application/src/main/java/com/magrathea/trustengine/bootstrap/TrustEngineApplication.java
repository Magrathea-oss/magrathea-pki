package com.magrathea.trustengine.bootstrap;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;

/**
 * Trust Engine — Reactive PKI, KMS, HSM, and TPM management bootstrap entry point.
 * <p>
 * Composition root for the Magrathea Trust Engine.
 * No domain, application, or infrastructure behavior lives here.
 */
@SpringBootApplication
public class TrustEngineApplication {

    public static void main(String[] args) {
        new SpringApplicationBuilder(TrustEngineApplication.class)
                .build()
                .run(args);
    }
}
