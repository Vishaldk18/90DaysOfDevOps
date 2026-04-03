# Task 1: Install & Verify

```bash
docker compose version
sudo apt update
sudo apt install docker-compose-plugin -y
docker compose version
````

---

# Task 2: Your First Compose File

```yaml
services:
  nginx:
    image: nginx:latest
    container_name: nginx-container
    ports:
      - "8080:80"
```

```bash
docker compose up -d
docker-compose down
```

---

# Task 3: Two-Container Setup

```yaml
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
```

---

# Task 4: Compose Commands

Start services in detached mode : docker compose up -d
View running services : docker compose ps
View logs of all services : docker compose logs or docker compose logs -f
View logs of a specific service : docker compose logs service-name
Stop services without removing : docker compose stop
Remove everything (containers, networks) : docker compose down / docker compose down -v (for volumes)
Rebuild images if you make a change : docker compose up -d --build
Restart services : docker cokpose restart

---

# Task 5: Environment Variables

## .env

```env
APP_ENV=production
APP_VERSION=v2
PORT=8080
```

```yaml
services:
  app:
    image: nginx
    ports:
      - "${PORT}:80"
    environment:
      APP_ENV: ${APP_ENV}
      APP_VERSION: ${APP_VERSION}
```
