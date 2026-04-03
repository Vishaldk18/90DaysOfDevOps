# 🐳 Docker Compose Project 

## 📦 Services Configuration

```yaml
services:
  web:
    build: .
    container_name: flask-app
    labels:
      app: flask-app
      tier: frontend
      environment: dev
    ports:
      - 5000:5000
    networks:
      - app-network
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy

  db:
    image: postgres:13
    container_name: postgres-db
    labels:
      app: mysql
      tier: database
      environment: dev
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    networks:
      - app-network
    restart: always
    volumes:
      - postgres-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U test"]
      interval: 5s
      timeout: 3s
      retries: 5

  redis:
    image: redis:latest
    container_name: redis-cache
    labels:
      app: redis
      tier: cache
      environment: dev
    networks:
      - app-network
    healthcheck:
      test: ["CMD-SHELL", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5

volumes:
  postgres-data:

networks:
  app-network:
    driver: bridge
````

---

# 🔁 Docker Restart Policy – Simple Notes

## 📌 What is Restart Policy?

Controls **what Docker does when a container stops or crashes**

---

## 🔹 1. no (default)

```yaml
restart: "no"
```

* Container will NOT restart
* Stops permanently

✅ Use:

* Debugging
* Testing

---

## 🔹 2. always

```yaml
restart: always
```

* Always restarts container
* Even after:

  * crash ✅
  * docker restart ✅
  * manual stop ❌ (it restarts again)

✅ Use:

* Critical services (web apps, APIs)

---

## 🔹 3. on-failure

```yaml
restart: on-failure
```

* Restarts ONLY if container fails (error)
* Does NOT restart if stopped manually

Optional:

```yaml
restart: on-failure:5
```

✅ Use:

* Jobs / scripts
* Batch processing

---

## 🔹 4. unless-stopped

```yaml
restart: unless-stopped
```

* Always restarts container
* BUT if you stop manually → stays stopped

✅ Use:

* Production apps (best choice)

---

## ⚖️ Quick Comparison

| Policy         | Crash | Docker Restart | Manual Stop |
| -------------- | ----- | -------------- | ----------- |
| no             | ❌     | ❌              | ✅           |
| always         | ✅     | ✅              | ❌           |
| on-failure     | ✅     | ❌              | ✅           |
| unless-stopped | ✅     | ✅              | ✅           |

---

## 🎯 Best Practice

```yaml
web:
  restart: unless-stopped

db:
  restart: unless-stopped

redis:
  restart: unless-stopped
```

---

## 💡 Key Point

* Restart policy works when container **stops**
* It does NOT check if app is healthy

👉 For health → use healthcheck

---

## 🔥 Interview Line

> "I use `unless-stopped` for production services to ensure availability with manual control."

---

# ⚖️ Docker Compose Scaling – Notes

## 🧪 Command Used

```bash
docker compose up -d --scale web=3
```

---

## 🔍 What Happens?

* Docker creates multiple containers:

  * web-1
  * web-2
  * web-3

* All containers are connected to same network ✅

* All can talk to DB and Redis internally ✅

---

## ❌ What Breaks?

### 1. Port Mapping Conflict

```yaml
ports:
  - "5000:5000"
```

👉 Problem:

* Only ONE container can use host port 5000
* Other containers FAIL to start or are ignored

---

### 2. container_name Issue (if used)

```yaml
container_name: flask-app
```

👉 Problem:

* Container names must be unique
* Scaling requires multiple containers

---

## 🧠 Why Simple Scaling Fails?

👉 Because of **Port Binding Limitation**

* Host machine has limited ports
* You cannot bind same port (5000) to multiple containers

👉 So:

```
Container 1 → 5000 ✅  
Container 2 → 5000 ❌  
Container 3 → 5000 ❌  
```

---

## 💡 Key Concept

* Scaling works INTERNALLY (Docker network)
* ❌ Fails EXTERNALLY (host port binding)

---

## ✅ Solution

### Option 1: Remove port mapping

* Let containers run internally
* Use reverse proxy (Nginx)

---

### Option 2: Use Load Balancer (Best)

```
User → Nginx → web-1 / web-2 / web-3
```

---

### Option 3: Random ports

```yaml
ports:
  - "5000"
```

👉 Docker assigns random ports (not ideal)

---

## 🔥 Final Understanding

* Docker Compose scaling works only for **stateless services**
* Needs **load balancer** for real usage

---

## 💥 Interview Answer

> "Simple scaling fails due to port binding conflicts, since multiple containers cannot share the same host port. A reverse proxy or load balancer is required to distribute traffic."

```
