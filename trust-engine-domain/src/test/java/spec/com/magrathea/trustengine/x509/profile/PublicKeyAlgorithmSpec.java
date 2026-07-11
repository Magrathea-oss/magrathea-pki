package spec.com.magrathea.trustengine.x509.profile;

import com.magrathea.trustengine.x509.profile.PublicKeyAlgorithm;

import java.util.Arrays;
import java.util.Set;
import java.util.stream.Collectors;

public class PublicKeyAlgorithmSpec extends PublicKeyAlgorithmSpecSupport {
    public void it_defines_the_complete_v1_public_key_algorithm_vocabulary() {
        shouldBeAnEnum();

        Set<String> vocabulary = Arrays.stream(PublicKeyAlgorithm.values())
                .map(PublicKeyAlgorithm::name)
                .collect(Collectors.toUnmodifiableSet());

        shouldEqual(vocabulary, Set.of("EC_P256", "RSA_3072"));
    }
}
