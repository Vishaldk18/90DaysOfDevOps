Task 1: Install & Verify
docker compose version
sudo apt update
sudo apt install docker-compose-plugin -y
docker compose version

Task 2: Your First Compose File

services:
  nginx:
    image: nginx:latest
    container_name: nginx-container
    ports:
      - "8080:80"


docker compose up -d
docker-compose down


Task 3: Two-Container Setup

services:
  db:
    image: mysql:8.0
    container_name: wordpress-db
    restart: on-failure
    environment:
      MYSQL_ROOT_PASSWORD: root123
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wpuser
      MYSQL_PASSWORD: wppass
    volumes:
      - mysql-data:/var/lib/mysql

  wordpress:
    image: wordpress:latest
    container_name: wordpress-app
    restart: on-failure
    depends_on:
      - db
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wpuser
      WORDPRESS_DB_PASSWORD: wppass
      WORDPRESS_DB_NAME: wordpress

volumes:
  mysql-data:
