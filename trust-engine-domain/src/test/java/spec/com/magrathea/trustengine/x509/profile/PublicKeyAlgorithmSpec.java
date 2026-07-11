package spec.com.magrathea.trustengine.x509.profile;

import com.magrathea.trustengine.x509.profile.PublicKeyAlgorithm;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.Arrays;
import java.util.Map;
import java.util.Optional;
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

    public void it_exposes_each_wire_token_as_explicit_immutable_case_sensitive_data() throws Exception {
        Map<PublicKeyAlgorithm, String> wireTokens = Arrays.stream(PublicKeyAlgorithm.values())
                .collect(Collectors.toUnmodifiableMap(algorithm -> algorithm, PublicKeyAlgorithm::wireToken));

        shouldEqual(wireTokens, Map.of(
                PublicKeyAlgorithm.EC_P256, "EC_P256",
                PublicKeyAlgorithm.RSA_3072, "RSA_3072"));

        Field field = PublicKeyAlgorithm.class.getDeclaredField("wireToken");
        shouldEqual(field.getType(), String.class);
        shouldEqual(field.getModifiers(), Modifier.PRIVATE | Modifier.FINAL);

        Constructor<?>[] constructors = PublicKeyAlgorithm.class.getDeclaredConstructors();
        shouldEqual(constructors.length, 1);
        shouldEqual(constructors[0].getModifiers(), Modifier.PRIVATE);

        Method accessor = PublicKeyAlgorithm.class.getDeclaredMethod("wireToken");
        shouldEqual(accessor.getReturnType(), String.class);
        shouldEqual(accessor.getModifiers(), Modifier.PUBLIC);
    }

    public void it_finds_only_an_exact_explicit_wire_token_match() throws Exception {
        shouldEqual(PublicKeyAlgorithm.findByWireToken("EC_P256"), Optional.of(PublicKeyAlgorithm.EC_P256));
        shouldEqual(PublicKeyAlgorithm.findByWireToken("ec_p256"), Optional.empty());

        Method finder = PublicKeyAlgorithm.class.getDeclaredMethod("findByWireToken", String.class);
        shouldEqual(finder.getReturnType(), Optional.class);
        shouldEqual(finder.getModifiers(), Modifier.PUBLIC | Modifier.STATIC);
    }
}
