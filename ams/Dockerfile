FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app
# COPY . .
COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jdk-jammy
COPY --from=build /app/target/*.war app.war
# COPY target/*.war app.war
ENTRYPOINT ["java","-jar","/app.war"]
