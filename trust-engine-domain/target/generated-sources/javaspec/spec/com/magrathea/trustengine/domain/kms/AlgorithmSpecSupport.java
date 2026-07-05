package spec.com.magrathea.trustengine.domain.kms;

import com.magrathea.trustengine.domain.kms.Algorithm;

public class AlgorithmSpecSupport extends io.github.jvmspec.api.ObjectBehavior<Algorithm> {
    public AlgorithmSpecSupport() {
        super(Algorithm.class);
    }

    protected io.github.jvmspec.matcher.Matchable<String> curveName() {
        return match(subject().curveName());
    }

    protected io.github.jvmspec.matcher.Matchable<Integer> keySize() {
        return match(subject().keySize());
    }

    @Override
    public AlgorithmThrowExpectation shouldThrow(Class<? extends Throwable> expectedType) {
        return new AlgorithmThrowExpectation(expectedType);
    }

    protected class AlgorithmThrowExpectation extends io.github.jvmspec.api.ObjectBehavior.ThrowExpectation {
        protected AlgorithmThrowExpectation(Class<? extends Throwable> expectedType) {
            super(AlgorithmSpecSupport.this, expectedType);
        }

        public void duringCurveName() {
            during(new io.github.jvmspec.api.ObjectBehavior.ThrowingRunnable() {
                @Override
                public void run() throws Throwable {
                    subject().curveName();
                }
            });
        }

        public void duringKeySize() {
            during(new io.github.jvmspec.api.ObjectBehavior.ThrowingRunnable() {
                @Override
                public void run() throws Throwable {
                    subject().keySize();
                }
            });
        }
    }
}
