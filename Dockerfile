# Use the official OpenJDK base image
FROM openjdk:17-jdk-slim

# Metadata as described above
LABEL maintainer="mycodeschoolro@gmail.com"
LABEL version="1.0"
LABEL description="Docker image for online-school-course-api Spring Boot application"

# Set the current working directory inside the image
WORKDIR /app
EXPOSE 8082
# Copy maven executable to the image
COPY mvnw .
COPY .mvn .mvn


# Copy the pom.xml file to download dependencies
COPY pom.xml .

# Grant execution permissions to the Maven wrapper script
RUN chmod +x mvnw

# Build all the dependencies in preparation to go offline.
# This is a separate step so the dependencies will be cached unless changes to pom.xml are made.
RUN ./mvnw dependency:go-offline -B

# Copy the project source
COPY src src

# Package the application
RUN ./mvnw package -DskipTests

# Specify the start command and entry point of the Spring Boot application
ENTRYPOINT ["java","-jar","/app/target/online-school-course-api-0.0.1-SNAPSHOT.jar"]