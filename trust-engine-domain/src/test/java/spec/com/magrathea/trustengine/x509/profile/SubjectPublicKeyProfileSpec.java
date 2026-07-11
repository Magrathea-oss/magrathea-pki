package spec.com.magrathea.trustengine.x509.profile;

import com.magrathea.trustengine.x509.profile.SubjectPublicKeyProfile;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.Arrays;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

public class SubjectPublicKeyProfileSpec extends SubjectPublicKeyProfileSpecSupport {
    public void it_preserves_the_exact_subject_public_key_profile_contract_under_its_domain_name() throws Exception {
        shouldBeAnEnum();

        Set<String> vocabulary = Arrays.stream(SubjectPublicKeyProfile.values())
                .map(SubjectPublicKeyProfile::name)
                .collect(Collectors.toUnmodifiableSet());
        shouldEqual(vocabulary, Set.of("EC_P256", "RSA_3072"));

        Map<SubjectPublicKeyProfile, String> wireTokens = Arrays.stream(SubjectPublicKeyProfile.values())
                .collect(Collectors.toUnmodifiableMap(profile -> profile, SubjectPublicKeyProfile::wireToken));
        shouldEqual(wireTokens, Map.of(
                SubjectPublicKeyProfile.EC_P256, "EC_P256",
                SubjectPublicKeyProfile.RSA_3072, "RSA_3072"));

        Field field = SubjectPublicKeyProfile.class.getDeclaredField("wireToken");
        shouldEqual(field.getType(), String.class);
        shouldEqual(field.getModifiers(), Modifier.PRIVATE | Modifier.FINAL);

        Constructor<?>[] constructors = SubjectPublicKeyProfile.class.getDeclaredConstructors();
        shouldEqual(constructors.length, 1);
        shouldEqual(constructors[0].getModifiers(), Modifier.PRIVATE);

        Method accessor = SubjectPublicKeyProfile.class.getDeclaredMethod("wireToken");
        shouldEqual(accessor.getReturnType(), String.class);
        shouldEqual(accessor.getModifiers(), Modifier.PUBLIC);

        shouldEqual(SubjectPublicKeyProfile.findByWireToken("EC_P256"),
                Optional.of(SubjectPublicKeyProfile.EC_P256));
        shouldEqual(SubjectPublicKeyProfile.findByWireToken("RSA_3072"),
                Optional.of(SubjectPublicKeyProfile.RSA_3072));
        shouldEqual(SubjectPublicKeyProfile.findByWireToken("ec_p256"), Optional.empty());
        shouldEqual(SubjectPublicKeyProfile.findByWireToken(" EC_P256"), Optional.empty());
        shouldEqual(SubjectPublicKeyProfile.findByWireToken("EC_P256 "), Optional.empty());

        Method finder = SubjectPublicKeyProfile.class.getDeclaredMethod("findByWireToken", String.class);
        shouldEqual(finder.getReturnType(), Optional.class);
        shouldEqual(finder.getModifiers(), Modifier.PUBLIC | Modifier.STATIC);
    }
}
