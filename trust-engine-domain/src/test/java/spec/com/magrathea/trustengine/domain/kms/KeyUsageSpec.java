package spec.com.magrathea.trustengine.domain.kms;

import com.magrathea.trustengine.domain.kms.KeyUsage;

public class KeyUsageSpec extends KeyUsageSpecSupport {
    public void it_is_a_enum() {
        shouldBeAnEnum();
    }

    public void it_has_expected_constants() {
        shouldHaveConstant("SIGN");
    }
}
