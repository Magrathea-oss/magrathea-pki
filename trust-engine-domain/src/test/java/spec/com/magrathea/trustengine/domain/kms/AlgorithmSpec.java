package spec.com.magrathea.trustengine.domain.kms;

import com.magrathea.trustengine.domain.kms.Algorithm;

public class AlgorithmSpec extends AlgorithmSpecSupport {
    public void it_is_a_enum() {
        shouldBeAnEnum();
    }

    public void it_has_expected_constants() {
        shouldHaveConstant("EC_P256", "secp256r1", 256);
    }

    public void it_has_curve_name() {
        beConstructedThrough("valueOf", "EC_P256");
        curveName().shouldReturn("secp256r1");
    }

    public void it_has_key_size() {
        beConstructedThrough("valueOf", "EC_P256");
        keySize().shouldReturn(256);
    }
}
