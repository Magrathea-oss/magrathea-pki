package spec.com.magrathea.trustengine.domain.kms;

import com.magrathea.trustengine.domain.kms.Algorithm;
import com.magrathea.trustengine.domain.kms.Key;
import com.magrathea.trustengine.domain.kms.KeyUsage;

public class KeySpec extends KeySpecSupport {
    public void it_is_constructible() {
        beConstructedWith(Algorithm.EC_P256, KeyUsage.SIGN, "code-signing-key");
        shouldHaveType(Key.class);
    }

    public void it_reports_its_algorithm() {
        beConstructedWith(Algorithm.EC_P256, KeyUsage.SIGN, "code-signing-key");
        algorithm().shouldReturn(Algorithm.EC_P256);
    }

    public void it_reports_its_usage() {
        beConstructedWith(Algorithm.EC_P256, KeyUsage.SIGN, "code-signing-key");
        usage().shouldReturn(KeyUsage.SIGN);
    }

    public void it_reports_its_label() {
        beConstructedWith(Algorithm.EC_P256, KeyUsage.SIGN, "code-signing-key");
        label().shouldReturn("code-signing-key");
    }

    public void it_generates_a_non_null_id() {
        beConstructedWith(Algorithm.EC_P256, KeyUsage.SIGN, "code-signing-key");
        id().shouldNotBe(null);
    }
}
