package spec.com.magrathea.trustengine.x509.profile;

public class CertificateProfileLifecycleEventEnvelopeSpec extends CertificateProfileLifecycleEventEnvelopeSpecSupport {
    public void it_exposes_the_lifecycle_event_type() {
        beConstructedWith("ProfileRegistered");

        eventType().shouldReturn("ProfileRegistered");
    }
}
