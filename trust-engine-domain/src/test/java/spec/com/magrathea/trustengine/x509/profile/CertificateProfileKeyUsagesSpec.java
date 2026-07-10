package spec.com.magrathea.trustengine.x509.profile;

public class CertificateProfileKeyUsagesSpec extends CertificateProfileKeyUsagesSpecSupport {
    public void it_renders_key_usages_in_canonical_order() {
        beConstructedWith((java.util.Set) java.util.Set.of("keyEncipherment", "digitalSignature"));

        canonicalJsonArray().shouldReturn("[\"digitalSignature\",\"keyEncipherment\"]");
    }
}
