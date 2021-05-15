####
# This Dockerfile is used in order to build a container that runs the Quarkus application in native (no JVM) mode
####
### Image for getting maven dependencies and then acting as a cache for the next image
FROM maven:3.6.3-jdk-11 as mavencache
ENV MAVEN_OPTS="-Dmaven.repo.local=/mvnrepo"
COPY pom.xml /app/
WORKDIR /app
RUN mvn test-compile -DskipTests=true dependency:resolve dependency:resolve-plugins
### Image for building the native binary
FROM ghcr.io/graalvm/graalvm-ce:ol7-java11-20.3.2 AS native-image
ENV MAVEN_OPTS="-Dmaven.repo.local=/mvnrepo"
COPY --from=mavencache /mvnrepo/ /mvnrepo/
COPY . /app
WORKDIR /app
ENV GRAALVM_HOME=/usr


ARG RESULT_LIB="/staticlibs"
RUN gu install native-image  && \
    mkdir ${RESULT_LIB} && \
    curl -L -o musl.tar.gz https://musl.libc.org/releases/musl-1.2.1.tar.gz && \
    mkdir musl && tar -xvzf musl.tar.gz -C musl --strip-components 1 && cd musl && \
    ./configure --disable-shared --prefix=${RESULT_LIB} && \
    make && make install && \
    cd .. && rm -rf /muscl && rm -f /musl.tar.gz
ENV PATH="$PATH:${RESULT_LIB}/bin"
ENV CC="musl-gcc"
RUN curl -L -o zlib.tar.gz https://zlib.net/zlib-1.2.11.tar.gz && \
   mkdir zlib && tar -xvzf zlib.tar.gz -C zlib --strip-components 1 && cd zlib && \
   ./configure --static --prefix=${RESULT_LIB} && \
    make && make install && \
    cd .. && rm -rf /zlib && rm -f /zlib.tar.gz
#END PRE-REQUISITES FOR STATIC NATIVE IMAGES FOR GRAAL 20.3.0
RUN native-image --static --libc=musl --enable-all-security-services --initialize-at-build-time=org.springframework.util.unit.DataSize -J-Xmx10G -J-Xms5G -H:+StaticExecutableWithDynamicLibC  \
      -H:Name=/layers/paketo-buildpacks_native-image/native-image/ch.sokube.employee.EmployeeApplication \
      -cp /workspace:/workspace/BOOT-INF/classes:/workspace/BOOT-INF/lib/spring-boot-2.4.3.jar:/workspace/BOOT-INF/lib/spring-boot-autoconfigure-2.4.3.jar:/workspace/BOOT-INF/lib/logback-classic-1.2.3.jar:/workspace/BOOT-INF/lib/logback-core-1.2.3.jar:/workspace/BOOT-INF/lib/log4j-to-slf4j-2.13.3.jar:/workspace/BOOT-INF/lib/log4j-api-2.13.3.jar:/workspace/BOOT-INF/lib/jul-to-slf4j-1.7.30.jar:/workspace/BOOT-INF/lib/jakarta.annotation-api-1.3.5.jar:/workspace/BOOT-INF/lib/snakeyaml-1.27.jar:/workspace/BOOT-INF/lib/spring-boot-actuator-autoconfigure-2.4.3.jar:/workspace/BOOT-INF/lib/spring-boot-actuator-2.4.3.jar:/workspace/BOOT-INF/lib/jackson-databind-2.11.4.jar:/workspace/BOOT-INF/lib/jackson-annotations-2.11.4.jar:/workspace/BOOT-INF/lib/jackson-core-2.11.4.jar:/workspace/BOOT-INF/lib/jackson-datatype-jsr310-2.11.4.jar:/workspace/BOOT-INF/lib/micrometer-core-1.6.4.jar:/workspace/BOOT-INF/lib/HdrHistogram-2.1.12.jar:/workspace/BOOT-INF/lib/LatencyUtils-2.0.3.jar:/workspace/BOOT-INF/lib/spring-aop-5.3.4.jar:/workspace/BOOT-INF/lib/aspectjweaver-1.9.6.jar:/workspace/BOOT-INF/lib/HikariCP-3.4.5.jar:/workspace/BOOT-INF/lib/spring-jdbc-5.3.4.jar:/workspace/BOOT-INF/lib/jakarta.transaction-api-1.3.3.jar:/workspace/BOOT-INF/lib/jakarta.persistence-api-2.2.3.jar:/workspace/BOOT-INF/lib/hibernate-core-5.4.28.Final.jar:/workspace/BOOT-INF/lib/jboss-logging-3.4.1.Final.jar:/workspace/BOOT-INF/lib/javassist-3.27.0-GA.jar:/workspace/BOOT-INF/lib/byte-buddy-1.10.20.jar:/workspace/BOOT-INF/lib/antlr-2.7.7.jar:/workspace/BOOT-INF/lib/jandex-2.2.3.Final.jar:/workspace/BOOT-INF/lib/classmate-1.5.1.jar:/workspace/BOOT-INF/lib/dom4j-2.1.3.jar:/workspace/BOOT-INF/lib/hibernate-commons-annotations-5.1.2.Final.jar:/workspace/BOOT-INF/lib/jaxb-runtime-2.3.3.jar:/workspace/BOOT-INF/lib/txw2-2.3.3.jar:/workspace/BOOT-INF/lib/istack-commons-runtime-3.0.11.jar:/workspace/BOOT-INF/lib/jakarta.activation-1.2.2.jar:/workspace/BOOT-INF/lib/spring-data-jpa-2.4.5.jar:/workspace/BOOT-INF/lib/spring-data-commons-2.4.5.jar:/workspace/BOOT-INF/lib/spring-orm-5.3.4.jar:/workspace/BOOT-INF/lib/spring-beans-5.3.4.jar:/workspace/BOOT-INF/lib/slf4j-api-1.7.30.jar:/workspace/BOOT-INF/lib/spring-aspects-5.3.4.jar:/workspace/BOOT-INF/lib/jackson-datatype-jdk8-2.11.4.jar:/workspace/BOOT-INF/lib/jackson-module-parameter-names-2.11.4.jar:/workspace/BOOT-INF/lib/tomcat-embed-core-9.0.43.jar:/workspace/BOOT-INF/lib/jakarta.el-3.0.3.jar:/workspace/BOOT-INF/lib/tomcat-embed-websocket-9.0.43.jar:/workspace/BOOT-INF/lib/spring-web-5.3.4.jar:/workspace/BOOT-INF/lib/spring-webmvc-5.3.4.jar:/workspace/BOOT-INF/lib/spring-expression-5.3.4.jar:/workspace/BOOT-INF/lib/h2-1.4.200.jar:/workspace/BOOT-INF/lib/postgresql-42.2.18.jar:/workspace/BOOT-INF/lib/checker-qual-3.5.0.jar:/workspace/BOOT-INF/lib/spring-kafka-2.5.4.RELEASE.jar:/workspace/BOOT-INF/lib/spring-context-5.3.4.jar:/workspace/BOOT-INF/lib/spring-messaging-5.3.4.jar:/workspace/BOOT-INF/lib/spring-tx-5.3.4.jar:/workspace/BOOT-INF/lib/spring-retry-1.3.1.jar:/workspace/BOOT-INF/lib/javax.annotation-api-1.3.2.jar:/workspace/BOOT-INF/lib/kafka-clients-2.6.0.jar:/workspace/BOOT-INF/lib/zstd-jni-1.4.4-7.jar:/workspace/BOOT-INF/lib/lz4-java-1.7.1.jar:/workspace/BOOT-INF/lib/snappy-java-1.1.7.3.jar:/workspace/BOOT-INF/lib/jakarta.xml.bind-api-2.3.3.jar:/workspace/BOOT-INF/lib/jakarta.activation-api-1.2.2.jar:/workspace/BOOT-INF/lib/spring-core-5.3.4.jar:/workspace/BOOT-INF/lib/spring-jcl-5.3.4.jar:/workspace/BOOT-INF/lib/reactor-netty-http-1.0.4.jar:/workspace/BOOT-INF/lib/netty-codec-http-4.1.59.Final.jar:/workspace/BOOT-INF/lib/netty-common-4.1.59.Final.jar:/workspace/BOOT-INF/lib/netty-buffer-4.1.59.Final.jar:/workspace/BOOT-INF/lib/netty-transport-4.1.59.Final.jar:/workspace/BOOT-INF/lib/netty-codec-4.1.59.Final.jar:/workspace/BOOT-INF/lib/netty-handler-4.1.59.Final.jar:/workspace/BOOT-INF/lib/netty-codec-http2-4.1.59.Final.jar:/workspace/BOOT-INF/lib/netty-resolver-dns-4.1.59.Final.jar:/workspace/BOOT-INF/lib/netty-resolver-4.1.59.Final.jar:/workspace/BOOT-INF/lib/netty-codec-dns-4.1.59.Final.jar:/workspace/BOOT-INF/lib/netty-resolver-dns-native-macos-4.1.59.Final-osx-x86_64.jar:/workspace/BOOT-INF/lib/netty-transport-native-unix-common-4.1.59.Final.jar:/workspace/BOOT-INF/lib/netty-transport-native-epoll-4.1.59.Final-linux-x86_64.jar:/workspace/BOOT-INF/lib/reactor-netty-core-1.0.4.jar:/workspace/BOOT-INF/lib/netty-handler-proxy-4.1.59.Final.jar:/workspace/BOOT-INF/lib/netty-codec-socks-4.1.59.Final.jar:/workspace/BOOT-INF/lib/spring-webflux-5.3.4.jar:/workspace/BOOT-INF/lib/reactor-core-3.4.3.jar:/workspace/BOOT-INF/lib/reactive-streams-1.0.3.jar:/workspace/BOOT-INF/lib/spring-native-0.9.2.jar:/workspace/BOOT-INF/lib/spring-boot-jarmode-layertools-2.4.3.jar \
      ch.sokube.employee.EmployeeApplication && \
    # Prepare everything for final image
    mkdir -p /dist && \
    cp /app/target/*-runner /dist/application

### Final image based on scratch containing only the binary
FROM scratch
COPY --chown=1000 --from=native-image /dist /work

EXPOSE 8080
USER 1000
WORKDIR /work/
CMD ["./application", "-Djava.io.tmpdir=/work/tmp"]