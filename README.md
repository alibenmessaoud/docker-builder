# docker-builder

###### Using Maven from Docker 

If you have been paying attention, the Dockerfiles are used to run applications that had been already compiled. This means that the machine that creates the Docker image needs to have a development environment as well (in our case a JDK and Maven).

In this example, we will allow Docker to build project source on a host machine by taking control on Maven :-). This means that Docker calls Maven commands from within a Docker container. While most people think Docker as a deployment format for the application itself, in reality, Docker can be used for the build process as well (i.e. tooling via Docker)

The app is simple project: 

```
├── Dockerfile
├── pom.xml
├── README.md
└── src
    ├── main
    │   └── java
    │       └── hello
    │           ├── Application.java
    │           ├── DataController.java
    │           └── Data.java
    └── test
        └── java
            └── hello
                └── DataControllerTests.java

7 directories, 7 files

```

To build the image:

`docker build -t cool_app .` 

To run the container based on the image named `cool_app`

`docker run -it a01 -p 8080:8080 sh`

```bash

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::        (v2.1.3.RELEASE)

2019-03-21 00:18:51.134  INFO 1 --- [           main] hello.Application                        : Starting Application v0.1.0 on 59725d04bb01 with PID 1 (/app.jar started by root in /)
2019-03-21 00:18:54.720  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2019-03-21 00:18:54.726  INFO 1 --- [           main] hello.Application                        : Started Application in 4.332 seconds (JVM running for 5.068)
```

Dockerfile

```dockerfile
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
```
