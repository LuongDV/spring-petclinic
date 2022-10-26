
FROM eclipse-temurin:17-jdk-jammy
ARG JAR_FILE=target/*.jar
WORKDIR /app
COPY ${JAR_FILE} application.jar
COPY docker-compose-dev.yml docker-compose-dev.yml

FROM base as dev
ENTRYPOINT ["java","-jar","application.jar", "-Dspring-boot.run.profiles=mysql", "-Dspring-boot.run.jvmArguments='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000'"]

FROM base as build
RUN ./mvnw package

FROM eclipse-temurin:17-jre-jammy as prod
EXPOSE 8080
COPY --from=build /app/target/spring-petclinic-*.jar /application.jar
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/application.jar"]
