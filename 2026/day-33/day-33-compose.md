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

# Task 4: Compose Commands (Well Formatted)

## 🚀 Start services in detached mode
```bash
docker compose up -d
````

---

## 👀 View running services

```bash
docker compose ps
```

---

## 📜 View logs of all services

```bash
docker compose logs
```

### 🔁 Follow logs (live)

```bash
docker compose logs -f
```

---

## 🔍 View logs of a specific service

```bash
docker compose logs service-name
```

### 🔁 Follow logs for a specific service

```bash
docker compose logs -f service-name
```

---

## ⏹️ Stop services without removing containers

```bash
docker compose stop
```

---

## 🗑️ Remove everything (containers + networks)

```bash
docker compose down
```

### ⚠️ Remove volumes also (DATA WILL BE LOST)

```bash
docker compose down -v
```

---

## 🔄 Rebuild images after changes

```bash
docker compose up -d --build
```

---

## 🔁 Restart services

```bash
docker compose restart
```

---

## ⚡ Full clean restart (Best Practice)

```bash
docker compose down
docker compose up -d --build
```

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
