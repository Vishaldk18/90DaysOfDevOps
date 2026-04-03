# Task 1: The Problem

```bash
docker run -d -e MYSQL_ROOT_PASSWORD=root mysql:8.0
docker exec -it fa3db7b485f8 bash
````

data is not persist when a volume is not attached to the container

---

# Task 2: Named Volumes

```bash
docker run -d -e MYSQL_ROOT_PASSWORD=root -v mysql-data:/var/lib/mysql mysql:8.0
docker exec -it fa3db7b485f8 bash
```

---

# Task 3: Bind Mounts

create index.html in bind folder

```bash
docker run -d -p 8085:80 -v /home/vishaldk18/bind:/usr/share/nginx/html nginx
```

---

# 🆚 Named Volume vs Bind Mount

## 🔹 1. Named Volume

👉 Managed by Docker itself

```bash
docker run -v my-volume:/data nginx
```

### ✅ Key Points:

* Stored in Docker’s internal directory (/var/lib/docker/volumes)
* Docker manages everything
* Safer & cleaner
* Best for databases / production

---

## 🔹 2. Bind Mount

👉 Direct link to your host folder

```bash
docker run -v /home/vishal/data:/data nginx
```

### ✅ Key Points:

* Uses your local filesystem
* Full control over files
* Changes reflect instantly
* Best for development

---

## ⚔️ Side-by-Side Comparison

| Feature      | Named Volume 🟢 | Bind Mount 🔵         |
| ------------ | --------------- | --------------------- |
| Managed by   | Docker          | You (host filesystem) |
| Location     | Docker internal | Specific host path    |
| Portability  | ✅ High          | ❌ Low                 |
| Safety       | ✅ Safer         | ⚠️ Risky              |
| Live updates | ❌ Not direct    | ✅ Instant             |
| Setup        | Easy            | Needs correct path    |
| Use case     | DB, production  | Dev, testing          |

---

## 🧠 Simple Way to Remember

* 📦 Named Volume = Docker-managed storage
* 📂 Bind Mount = Your folder directly inside container

---

## 🔥 Real DevOps Use Cases

### 🟢 Named Volume

* MySQL / PostgreSQL data
* Application persistent data
* Production workloads

### 🔵 Bind Mount

* Code development
* Live reload apps
* Debugging

---

## ⚠️ Important Gotcha

👉 Bind mount can overwrite container files:

```bash
-v /empty-folder:/usr/share/nginx/html
```

➡️ Your website disappears 😅

---

## 🧠 Interview Perfect Answer

Named volumes are managed by Docker and provide better portability and safety, making them ideal for production and persistent data. Bind mounts directly map a host directory into a container, allowing real-time file changes, which makes them suitable for development but less portable.

---

# Task 4: Docker Networking Basics

```bash
docker network ls
docker network inspect id/name
```

default network is bridged

```bash
docker run -itd --name c1 alpine sh
docker run -itd --name c2 alpine sh
```

```bash
docker exec -it c1 sh
ping c2
```

(fails)

Default bridge does NOT support DNS resolution
Container names are not resolvable

```bash
docker inspect c2 | grep IPAddress
docker exec -it c1 sh
ping IP
```

(works)

All containers on default bridge share same network
They can communicate using IP addresses

---

# Task 5: Custom Networks

```bash
docker network create my-app-net
docker network ls
docker run -itd --name c1 --network my-app-net alpine sh
docker run -itd --name c2 --network my-app-net alpine sh
```

```bash
docker exec -it c2 sh
ping c1
```

(works)

```bash
ping IP(c1)
```

works

On the default bridge network, containers cannot communicate using names because DNS resolution is not supported, but they can communicate using IP addresses. In contrast, user-defined bridge networks support both name and IP-based communication.

---

## Why does custom networking allow name-based communication but the default bridge doesn't?

Custom Docker networks include an embedded DNS server that enables containers to resolve each other by name, supporting service discovery. The default bridge network lacks this DNS feature, so containers can only communicate using IP addresses.

---

# Task 6: Put It Together

```bash
docker network create test-network
docker volume create test-volume

docker run -d \
  --name db \
  --network test-network \
  -v test-volume:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  mysql:8.0

docker run -d \
  --name app \
  --network test-network \
  nginx
```

```bash
docker exec -it nginx bash
apt upate
apt install iputils-ping -y
```

```bash
ping db
```

(works)
