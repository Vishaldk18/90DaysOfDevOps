# 🐳 Docker Cheat Sheet

---

## 📦 Container Commands

- `docker run <image>` → Run a new container from an image  
- `docker ps` → List running containers  
- `docker ps -a` → List all containers (including stopped)  
- `docker stop <container>` → Stop a running container  
- `docker rm <container>` → Remove a container  
- `docker exec -it <container> sh` → Execute command inside container  
- `docker logs <container>` → View container logs  

---

## 🖼️ Image Commands

- `docker build -t <name> .` → Build image from Dockerfile  
- `docker pull <image>` → Download image from registry  
- `docker push <image>` → Upload image to registry  
- `docker tag <image> <repo>:<tag>` → Tag image for registry  
- `docker images` → List all images  
- `docker rmi <image>` → Remove image  

---

## 💾 Volume Commands

- `docker volume create <name>` → Create a volume  
- `docker volume ls` → List volumes  
- `docker volume inspect <name>` → Show volume details  
- `docker volume rm <name>` → Remove a volume  

---

## 🌐 Network Commands

- `docker network create <name>` → Create a network  
- `docker network ls` → List networks  
- `docker network inspect <name>` → Show network details  
- `docker network connect <network> <container>` → Connect container to network  

---

## ⚙️ Docker Compose Commands

- `docker compose up -d` → Start services in background  
- `docker compose down` → Stop and remove services  
- `docker compose ps` → List compose services  
- `docker compose logs` → View logs of services  
- `docker compose build` → Build services  

---

## 🧹 Cleanup Commands

- `docker system prune` → Remove unused data  
- `docker system prune -a` → Remove all unused images + data  
- `docker system df` → Show Docker disk usage  

---

## 🧱 Dockerfile Instructions

- `FROM` → Set base image  
- `RUN` → Execute commands during build  
- `COPY` → Copy files into image  
- `WORKDIR` → Set working directory  
- `EXPOSE` → Define container port  
- `CMD` → Default command to run container  
- `ENTRYPOINT` → Set main executable  

---
