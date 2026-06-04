# ─────────────────────────────────────────────────────
# Stage 1: Build the WAR with Maven
# ─────────────────────────────────────────────────────
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom.xml first for dependency caching
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests -B

# ─────────────────────────────────────────────────────
# Stage 2: Run on Tomcat 10.1 + JDK 17
# ─────────────────────────────────────────────────────
FROM tomcat:10.1-jdk17

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy built WAR as ROOT (serves at /)
COPY --from=builder /app/target/reelkaro.war /usr/local/tomcat/webapps/ROOT.war

# Render requires the app to listen on $PORT (default 8080)
EXPOSE 8080

CMD ["catalina.sh", "run"]
