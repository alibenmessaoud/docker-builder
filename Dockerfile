## Prepare env to build sources
# =============================================
# Start with a base image containing Maven and Java runtime for build
FROM maven:3.5.2-jdk-8-alpine AS MAVEN_TOOL_CHAIN

# Add Maintainer Info
LABEL maintainer="app.io"

# Copy sources
COPY pom.xml /tmp/
COPY src /tmp/src/
WORKDIR /tmp/

# Build and package app
RUN mvn package

## Run app after building sources
# =============================================
# Start with a base image containing Java runtime for run
FROM openjdk:8-jdk-alpine

# The application's jar file
COPY --from=MAVEN_TOOL_CHAIN /tmp/target/io-app-service*.jar app.jar

# Java env varaibles
ENV JAVA_OPTS=""
# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the jar file
ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar
