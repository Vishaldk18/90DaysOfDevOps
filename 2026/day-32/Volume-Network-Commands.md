# 📦 Docker Volumes Cheat Sheet

## 🔹 Create Volume

```bash
docker volume create my-volume
```

## 🔹 List Volumes

```bash
docker volume ls
```

## 🔹 Inspect Volume

```bash
docker volume inspect my-volume
```

## 🔹 Remove Volume

```bash
docker volume rm my-volume
```

## 🔹 Remove Unused Volumes

```bash
docker volume prune
```

---

## 🔹 Use Volume in Container

```bash
docker run -d \
  --name mysql \
  -v my-volume:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  mysql:8.0
```

---

## 🔹 Access Volume Data (Safe Way)

```bash
docker run -it -v my-volume:/data alpine sh
```

---

# 📂 Bind Mount Cheat Sheet

## 🔹 Basic Bind Mount

```bash
docker run -d \
  -p 8080:80 \
  -v /host/path:/container/path \
  nginx
```

---

## 🔹 Using Current Directory (Dev only)

```bash
docker run -d -p 8080:80 \
  -v $(pwd):/usr/share/nginx/html \
  nginx
```

---

## 🔹 Read-Only Bind Mount

```bash
docker run -d \
  -v /host/path:/data:ro \
  nginx
```

---

## 🔹 Mount Using --mount (Recommended)

```bash
docker run -d \
  --mount type=bind,source=/host/path,target=/data \
  nginx
```

---

# 🌐 Docker Networking Cheat Sheet

## 🔹 List Networks

```bash
docker network ls
```

## 🔹 Inspect Network

```bash
docker network inspect bridge
```

---

## 🔹 Create Custom Network

```bash
docker network create my-network
```

---

## 🔹 Run Container on Network

```bash
docker run -d --name c1 --network my-network alpine sleep 1000
docker run -d --name c2 --network my-network alpine sleep 1000
```

---

## 🔹 Test Connectivity (Name-based)

```bash
docker exec -it c1 sh
ping c2
```

---

## 🔹 Connect Existing Container to Network

```bash
docker network connect my-network container-name
```

---

## 🔹 Disconnect Container

```bash
docker network disconnect my-network container-name
```

---

## 🔹 Remove Network

```bash
docker network rm my-network
```

---

# ⚡ Quick Comparison Commands

## 🔹 Volume vs Bind Mount

```bash
# Named Volume
docker run -v my-volume:/data nginx

# Bind Mount
docker run -v /host/path:/data nginx
```

---

# 🧠 Debugging Commands (IMPORTANT)

## 🔹 Check Running Containers

```bash
docker ps
```

## 🔹 Check All Containers

```bash
docker ps -a
```

## 🔹 Get Container IP

```bash
docker inspect container-name | grep IPAddress
```

## 🔹 Enter Container

```bash
docker exec -it container-name sh
```

---

# 🔥 Pro DevOps Tips

* Use **Volumes → Databases**
* Use **Bind Mounts → Development**
* Use **Custom Networks → Microservices**
* Avoid default bridge in real projects

---

# 🧠 Interview One-Liner

> Docker volumes provide persistent storage managed by Docker, bind mounts map host directories for real-time access, and custom networks enable container communication with built-in DNS.

---
