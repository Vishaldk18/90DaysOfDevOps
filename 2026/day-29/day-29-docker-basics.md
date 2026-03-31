## What is Docker?
Docker is a containerization platform that lets you build applications, package them with all dependencies, and run them anywhere consistently.

## Why Docker?
- No “works on my machine” problem  
- Fast deployment  
- Lightweight compared to VMs  

---

## What is a Container?
A container is a lightweight, standalone executable package that includes application code, runtime, libraries, and dependencies.

---

## Why Do We Need Containers?

### Without containers 😵:
- App works on dev machine ❌ fails on server  
- Dependency conflicts  
- Different OS issues  

### With containers 🚀:
- Same environment everywhere  
- Easy CI/CD  
- Fast startup  
- Isolation between apps  

👉 Key Idea: **Consistency + Portability**

---

## ⚔️ Containers vs Virtual Machines (IMPORTANT)

| Feature      | Containers 🐳         | Virtual Machines 🖥️   |
| ------------ | --------------------- | ---------------------- |
| OS           | Share host OS         | Each VM has its own OS |
| Size         | Lightweight (MBs)     | Heavy (GBs)            |
| Startup Time | Seconds               | Minutes                |
| Performance  | Near native           | Slower                 |
| Isolation    | Process-level         | Full OS-level          |
| Use Case     | Microservices, DevOps | Full system isolation  |

VM = Full house 🏠 (with own kitchen, bathroom, everything)  
Container = Apartment 🏢 (shared building, private space)

---

## Docker Architecture

### 1) Docker Client  
Docker client is the interface through which users interact with Docker. It uses commands like `docker run`, `docker build`, `docker pull`. It sends requests to the Docker daemon using REST API.

### 2) Docker Daemon (dockerd)  
`dockerd` is the core component of Docker responsible for building Docker images, running containers, and managing networks and volumes. It listens to Docker API requests and processes them.

### 3) Docker Images  
Docker images are read-only templates (blueprints) used to create containers. They contain application code, dependencies, libraries, and OS layers. Built using a Dockerfile.

### 4) Docker Container  
A container is a running instance of a Docker image. It is lightweight, shares the host OS kernel, and can be started, stopped, and deleted.  

Image = Blueprint  
Container = Running application  

### 5) Docker Registry  
Docker registry stores Docker images. It is used to push and pull images.  

- Public Registry: Docker Hub  
- Private Registry:  
  - AWS ECR  
  - Google Container Registry  

---

## Workflow

- User runs a command using Docker Client  
- Client sends request to Docker Daemon  
- Daemon checks if image exists locally  
- If not, pulls image from Registry  
- Daemon creates and runs container from image  

```

```
User → Docker Client → Docker Daemon → Docker Image → Container
                                   ↓
                              Docker Registry
```

---

# 🐳 Docker Basic Commands Cheat Sheet

---

## 🔹 Images

```bash
docker pull nginx        # Download image
docker images            # List images
docker rmi nginx         # Remove image
```

---

## 🔹 Containers

```bash
docker run nginx                     # Run container
docker run -d nginx                  # Run in background
docker run -it ubuntu /bin/bash      # Interactive mode

docker ps                            # Running containers
docker ps -a                         # All containers

docker stop <id>                     # Stop container
docker start <id>                    # Start container
docker restart <id>                  # Restart container

docker rm <id>                       # Delete container
```

---

## 🔹 Debugging

```bash
docker logs <id>                     # View logs
docker exec -it <id> /bin/bash       # Access container shell
docker inspect <id>                  # Detailed info
```

---

## 🔹 Build & Run

```bash
docker build -t myapp .              # Build image
docker run -d -p 8080:80 myapp       # Run with port mapping
```

---

## 🔹 Cleanup

```bash
docker container prune               # Remove stopped containers
docker image prune                   # Remove unused images
docker system prune -a               # Clean everything
```

---

## 🧠 Must-Remember (Top Commands)

```bash
docker run
docker ps
docker images
docker stop
docker rm
docker logs
docker exec
docker build
```
