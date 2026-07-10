package spec.com.magrathea.trustengine.x509.profile;

public class CertificateProfileBasicConstraintsSpec extends CertificateProfileBasicConstraintsSpecSupport {
    public void it_renders_the_ca_flag_as_a_canonical_json_object() {
        beConstructedWith((boolean) false);

        canonicalJsonObject().shouldReturn("{\"ca\":false}");
    }
}
