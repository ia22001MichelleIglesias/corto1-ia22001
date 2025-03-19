FROM maven:3.8.4-openjdk-17-slim AS build
    WORKDIR /app
    ENV MAVEN_CONFIG=""
    COPY .mvn/ .mvn/
    COPY mvnw pom.xml ./
    RUN chmod +x mvnw
    RUN ./mvnw dependency:go-offline
    COPY src/ src/
    RUN ./mvnw clean package -DskipTests
    
    FROM openjdk:17-slim
    WORKDIR /app
    
    COPY --from=build /app/target/*.jar app.jar
    
    EXPOSE 8080
    
    ENTRYPOINT ["java", "-jar", "app.jar"]