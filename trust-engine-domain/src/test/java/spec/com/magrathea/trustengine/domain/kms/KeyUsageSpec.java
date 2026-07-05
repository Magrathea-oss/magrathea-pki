package spec.com.magrathea.trustengine.domain.kms;

import com.magrathea.trustengine.domain.kms.KeyUsage;

public class KeyUsageSpec extends KeyUsageSpecSupport {
    public void it_is_an_enum() {
        shouldBeAnEnum();
    }

    public void it_has_the_sign_constant() {
        shouldHaveConstant("SIGN");
    }
}
