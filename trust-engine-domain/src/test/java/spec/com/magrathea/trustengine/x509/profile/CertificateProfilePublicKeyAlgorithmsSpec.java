package spec.com.magrathea.trustengine.x509.profile;

public class CertificateProfilePublicKeyAlgorithmsSpec extends CertificateProfilePublicKeyAlgorithmsSpecSupport {
    public void it_renders_public_key_algorithms_in_canonical_order() {
        beConstructedWith((java.util.Set) java.util.Set.of("RSA_3072", "EC_P256"));

        canonicalJsonArray().shouldReturn("[\"EC_P256\",\"RSA_3072\"]");
    }
}
