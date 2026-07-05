# Stage 1: Build from source through Maven
FROM maven:3.9-eclipse-temurin-21-alpine AS builder

WORKDIR /build

# Copy pom.xml files and source
COPY pom.xml .
COPY trust-engine-domain/pom.xml ./trust-engine-domain/
COPY trust-engine-application/pom.xml ./trust-engine-application/
COPY trust-engine-infrastructure/pom.xml ./trust-engine-infrastructure/
COPY trust-engine-api-adapter/pom.xml ./trust-engine-api-adapter/
COPY trust-engine-cli-adapter/pom.xml ./trust-engine-cli-adapter/
COPY bootstrap-application/pom.xml ./bootstrap-application/

# Copy source directories
COPY trust-engine-domain/src ./trust-engine-domain/src/
COPY trust-engine-application/src ./trust-engine-application/src/
COPY trust-engine-infrastructure/src ./trust-engine-infrastructure/src/
COPY trust-engine-api-adapter/src ./trust-engine-api-adapter/src/
COPY trust-engine-cli-adapter/src ./trust-engine-cli-adapter/src/
COPY bootstrap-application/src ./bootstrap-application/src/

# Build and package (skip tests for image build)
RUN mvn package -DskipTests --no-transfer-progress

# Stage 2: Minimal JRE runtime
FROM eclipse-temurin:21-jre-alpine AS runtime

WORKDIR /app

# Copy only the bootstrapped application JAR
COPY --from=builder /build/bootstrap-application/target/*.jar app.jar

# Expose port
EXPOSE 8080

# Healthcheck — uses /actuator/health endpoint via wget
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
