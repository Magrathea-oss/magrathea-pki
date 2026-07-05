package spec.com.magrathea.trustengine.domain.kms;

import com.magrathea.trustengine.domain.kms.Key;

public class KeySpecSupport extends io.github.jvmspec.api.ObjectBehavior<Key> {
    public KeySpecSupport() {
        super(Key.class);
    }

    protected io.github.jvmspec.matcher.Matchable<com.magrathea.trustengine.domain.kms.Algorithm> algorithm() {
        return match(subject().algorithm());
    }

    protected io.github.jvmspec.matcher.Matchable<com.magrathea.trustengine.domain.kms.KeyUsage> usage() {
        return match(subject().usage());
    }

    protected io.github.jvmspec.matcher.Matchable<String> label() {
        return match(subject().label());
    }

    protected io.github.jvmspec.matcher.Matchable<Object> id() {
        return match(subject().id());
    }

    @Override
    public KeyThrowExpectation shouldThrow(Class<? extends Throwable> expectedType) {
        return new KeyThrowExpectation(expectedType);
    }

    protected class KeyThrowExpectation extends io.github.jvmspec.api.ObjectBehavior.ThrowExpectation {
        protected KeyThrowExpectation(Class<? extends Throwable> expectedType) {
            super(KeySpecSupport.this, expectedType);
        }

        public void duringAlgorithm() {
            during(new io.github.jvmspec.api.ObjectBehavior.ThrowingRunnable() {
                @Override
                public void run() throws Throwable {
                    subject().algorithm();
                }
            });
        }

        public void duringUsage() {
            during(new io.github.jvmspec.api.ObjectBehavior.ThrowingRunnable() {
                @Override
                public void run() throws Throwable {
                    subject().usage();
                }
            });
        }

        public void duringLabel() {
            during(new io.github.jvmspec.api.ObjectBehavior.ThrowingRunnable() {
                @Override
                public void run() throws Throwable {
                    subject().label();
                }
            });
        }

        public void duringId() {
            during(new io.github.jvmspec.api.ObjectBehavior.ThrowingRunnable() {
                @Override
                public void run() throws Throwable {
                    subject().id();
                }
            });
        }
    }
}
