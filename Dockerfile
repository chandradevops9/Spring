# Stage 1: Build the application
FROM maven:3.8.5-openjdk-8-slim AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests && ls -l target

# Stage 2: Run the application
FROM openjdk:8-alpine
ENV PROJECT_HOME=/opt/app
WORKDIR $PROJECT_HOME

# Copy the actual jar file (update the name if needed)
COPY --from=build /app/target/spring-boot-mongo-1.0-SNAPSHOT.jar $PROJECT_HOME/spring-boot-mongo.jar

EXPOSE 8080
CMD ["java", "-jar", "./spring-boot-mongo.jar"]
