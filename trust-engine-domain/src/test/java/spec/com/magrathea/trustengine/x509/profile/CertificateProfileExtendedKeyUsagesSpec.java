package spec.com.magrathea.trustengine.x509.profile;

public class CertificateProfileExtendedKeyUsagesSpec extends CertificateProfileExtendedKeyUsagesSpecSupport {
    public void it_renders_extended_key_usages_in_canonical_order() {
        beConstructedWith((java.util.Set) java.util.Set.of("serverAuth", "clientAuth"));

        canonicalJsonArray().shouldReturn("[\"clientAuth\",\"serverAuth\"]");
    }
}
