FROM eclipse-temurin:21-jdk-jammy

WORKDIR /app

COPY . .

RUN chmod +x mvnw && ./mvnw clean package -DskipTests

EXPOSE 8080

ENTRYPOINT ["sh","-c","java -jar target/*.jar"]



services:
  mysql:
    image: mysql:8.0
    container_name: mysql
    environment:
      MYSQL_ROOT_PASSWORD: Test@123
      MYSQL_DATABASE: bankappdb
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
    networks:
      - bankapp-nw
    healthcheck:
     test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-pTest@123"]
     interval: 1m30s
     timeout: 10s
     retries: 3
     start_period: 30s

  bankapp:
    build: .
    container_name: bankapp
    ports:
      - "8082:8080"
    networks:
      - bankapp-nw
    environment:
      MYSQL_HOST: mysql
      MYSQL_PORT: 3306
      MYSQL_DATABASE: bankappdb
      MYSQL_USER: root
      MYSQL_PASSWORD: Test@123
      OLLAMA_URL: http://ollama:11434
    depends_on:
      mysql:
        condition: service_healthy

  ollama:
    image: ollama/ollama
    container_name: ollama
    ports:
      - "11434:11434"
    networks:
      - bankapp-nw
    volumes:
      - ollama-data:/root/.ollama



networks:
  bankapp-nw:
    driver: bridge

volumes:
  mysql-data:
  ollama-data:
