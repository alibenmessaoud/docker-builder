# docker-builder

#### Introduction

If you have been paying attention, the Dockerfiles are used to run applications that had been already compiled. This means that the machine that creates the Docker image needs to have a development environment as well (in our case a JDK and Maven or Node.JS and NPM).

In this example, we will allow Docker to build project source on a host machine by taking control on Maven and NPM. For a Java app, this means that Docker calls Maven commands from within a Docker container. For a JS app, Docker calls NPM commands from within a Docker container. 

While most people think Docker as a deployment format for the application itself, in reality, Docker can be used for the build process as well (i.e. tooling via Docker)

##### Using Maven from Docker 

The Java project has the following structure: 

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

Build the image: `docker build -t ijava_app .` 

Run the container based on the image: `docker run --name cjava_app -p 90:8080 ijava_app`

Run curl to test `curl http://localhost:90/greeting` to see `{"content":"Hello, World!"}`

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
FROM maven:3.5.2-jdk-8-alpine AS MAVEN_TOOL_CHAIN

LABEL maintainer="app.io"

COPY pom.xml /tmp/
COPY src /tmp/src/
WORKDIR /tmp/

RUN mvn package

FROM openjdk:8-jdk-alpine

COPY --from=MAVEN_TOOL_CHAIN /tmp/target/io-app-service*.jar app.jar

ENV JAVA_OPTS=""

EXPOSE 8080

ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar
```

##### Using Node from Docker

The JS project has the following structure:

```bash
├── app.js
├── Dockerfile
├── package.json
└── views
    ├── css
    │   └── styles.css
    ├── index.html
    └── sharks.html

```

Build the image: `docker build -t inode_app .` 

Run the container based on the image: `docker run --name cnode_app -p 91:8080 inode_app`

Run curl to test `curl http://localhost:91/greeting` to see `{"content":"Hello, World!"}`

```sh
Example app listening on port 8080!
/GET
```

Docker

```dockerfile
FROM node:10-alpine

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY package*.json ./

USER node

RUN npm install

COPY --chown=node:node . .

EXPOSE 8080

CMD [ "node", "app.js" ]
```



