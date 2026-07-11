package spec.com.magrathea.trustengine.x509.profile;

import java.time.Instant;

public class CertificateProfileLifecycleEventEnvelopeSpec extends CertificateProfileLifecycleEventEnvelopeSpecSupport {
    public void it_exposes_the_lifecycle_event_type() {
        beConstructedWith("ProfileRegistered", "x509-profile/tls-server-baseline", 1L, "ra-operator@example.test");

        eventType().shouldReturn("ProfileRegistered");
    }

    public void it_exposes_the_lifecycle_aggregate_identifier() {
        beConstructedWith("CERTIFICATE_PROFILE_REGISTERED", "x509-profile/tls-server-baseline", 1L, "ra-operator@example.test");

        aggregateId().shouldReturn("x509-profile/tls-server-baseline");
    }

    public void it_exposes_the_lifecycle_aggregate_version() {
        beConstructedWith("CERTIFICATE_PROFILE_REGISTERED", "x509-profile/tls-server-baseline", 1L, "ra-operator@example.test");

        aggregateVersion().shouldReturn(1L);
    }

    public void it_exposes_the_lifecycle_actor() {
        beConstructedWith("CERTIFICATE_PROFILE_REGISTERED", "x509-profile/tls-server-baseline", 1L, "ra-operator@example.test");

        actor().shouldReturn("ra-operator@example.test");
    }

    public void it_exposes_the_lifecycle_event_identifier() {
        beConstructedWith("CERTIFICATE_PROFILE_REGISTERED", "x509-profile/tls-server-baseline", 1L, "ra-operator@example.test", "evt-x509-profile-2026-0001");

        eventId().shouldReturn("evt-x509-profile-2026-0001");
    }

    public void it_exposes_the_lifecycle_occurrence_timestamp() {
        Instant occurredAt = Instant.parse("2026-07-10T12:34:56Z");
        beConstructedWith("CERTIFICATE_PROFILE_REGISTERED", "x509-profile/tls-server-baseline", 1L, "ra-operator@example.test", "evt-x509-profile-2026-0001", occurredAt);

        occurredAt().shouldReturn(occurredAt);
    }

    public void it_exposes_the_lifecycle_causation_identifier() {
        Instant occurredAt = Instant.parse("2026-07-10T12:34:56Z");
        beConstructedWith("CERTIFICATE_PROFILE_REGISTERED", "x509-profile/tls-server-baseline", 1L, "ra-operator@example.test", "evt-x509-profile-2026-0001", occurredAt, "cmd-register-profile-2026-0001");

        causationId().shouldReturn("cmd-register-profile-2026-0001");
    }

    public void it_exposes_the_lifecycle_correlation_identifier() {
        Instant occurredAt = Instant.parse("2026-07-10T12:34:56Z");
        beConstructedWith("CERTIFICATE_PROFILE_REGISTERED", "x509-profile/tls-server-baseline", 1L, "ra-operator@example.test", "evt-x509-profile-2026-0001", occurredAt, "cmd-register-profile-2026-0001", "profile-onboarding-2026-0001");

        correlationId().shouldReturn("profile-onboarding-2026-0001");
    }
}
