package spec.com.magrathea.trustengine.domain.kms;

import com.magrathea.trustengine.domain.kms.Algorithm;

public class AlgorithmSpec extends AlgorithmSpecSupport {
    public void it_is_an_enum() {
        shouldBeAnEnum();
    }

    public void it_has_the_ec_p256_constant() {
        shouldHaveConstant("EC_P256");
    }

    public void it_reports_its_curve_name() {
        beConstructedThrough("valueOf", "EC_P256");
        curveName().shouldReturn("secp256r1");
    }

    public void it_reports_its_key_size() {
        beConstructedThrough("valueOf", "EC_P256");
        keySize().shouldReturn(256);
    }
}
