# Episode 0001 independent evidence

- Sealed RAW_EVENT_STREAM: 311 events; sequence, hash chain, seal, and 60 tool pairs pass.
- Provenance: `spec-driven`, `bdd-java-spec-driven-v8`, complete tool registry, and JavaSpec 1.0.0-RC1 exact-JAR fingerprint before baseline.
- New subject: clean initial Git; empty replacement corpus; both files absent; `javaspec describe` created the initial spec before its first edit and did not create production.
- RED: selected no-write dry-run exited 1 on the missing record and explicitly wrote no files.
- Generation: `javaspec run --generate` first created production and reported the exact generated record path. Its stub failed meaningfully.
- GREEN: one bounded edit produced `public record CertificateProfileId(String value) {}`.
- Cache incident: stale ignored `target/javaspec-classes` caused `NoSuchMethodError`; a generate retry left production byte-identical. Removing only that ignored build-output directory refreshed compilation. No behavior was bypassed.
- Verification: selected/subject/full 1/1; zero stubs; exact shape; official OpenJDK 21.0.11 Maven one test; zero unsupported warnings.
- Scope: implementation commit contains exactly the two authorized source files; sealed final worktree clean.
- Curation: `CURATED_SFT_CANDIDATE`; final SFT requires independent approval.
