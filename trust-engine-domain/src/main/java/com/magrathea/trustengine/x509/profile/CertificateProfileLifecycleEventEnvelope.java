package com.magrathea.trustengine.x509.profile;

public record CertificateProfileLifecycleEventEnvelope(String eventType, String aggregateId, long aggregateVersion, String actor, String eventId, java.time.Instant occurredAt, String causationId, String correlationId, String schemaVersion) {
}
