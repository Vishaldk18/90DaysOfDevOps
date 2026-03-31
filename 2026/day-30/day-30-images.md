# Task 1: Docker Images

```bash
docker pull alpine
docker pull nginx
docker pull ubuntu

docker image ls
````

## ❓ Ubuntu vs Alpine — why is one much smaller?

Alpine is much smaller than Ubuntu because it is a minimal Linux distribution that uses musl libc and BusyBox, includes only essential components, and avoids unnecessary packages, whereas Ubuntu is a full-featured OS with glibc and many pre-installed utilities, making it larger.

---

## 🔍 Inspect an Image — what information can you see?

Shows detailed JSON metadata about the image.

Helps you understand:

* Layers
* Environment variables
* Entrypoint / CMD
* OS & architecture
* Size and config

---

# Task 2: Image Layers

## 🔹 Run history command

```bash
docker image history nginx
```

### ❓ What do you see?

`docker image history` shows the layer-by-layer history of a Docker image, including the commands used to create each layer and their sizes, which helps in understanding and optimizing the image.

---

## ❓ What are Docker Layers?

Layers are the building blocks of a Docker image.

Docker layers are read-only filesystem layers created for each instruction in a Dockerfile. Docker uses layers to enable efficient storage, caching, faster builds, and reuse across images, making containers lightweight and performant.

---

### 🔹 Key Points

* Every instruction in a Dockerfile creates a new layer
* Layers are:

  * Read-only
  * Stacked on top of each other

---

### 🔹 Example

```dockerfile
FROM ubuntu
RUN apt-get update
RUN apt-get install nginx
COPY . /app
CMD ["nginx"]
```

### 🔹 Layers

* Layer 1 → Ubuntu base
* Layer 2 → apt-get update
* Layer 3 → install nginx
* Layer 4 → copy files
* Layer 5 → CMD

---

# Task 3: Container Lifecycle

## 🔹 Create a container (without starting it)

```bash
docker create --name mycontainer nginx
```

State: **created**

---

## ▶️ Start the container

```bash
docker start mycontainer
```

State: **up/running**

---

## ⏸️ Pause it

(Freezes container processes — CPU stopped)

```bash
docker pause mycontainer
```

State: **paused**

---

## ▶️ Unpause it

```bash
docker unpause mycontainer
```

State: **up/running**

---

## ⛔ Stop it

(Graceful — SIGTERM)

```bash
docker stop mycontainer
```

State: **exited**

---

## 🔁 Restart it

```bash
docker restart mycontainer
```

State: **up/running**

---

## 💀 Kill it

(Force — SIGKILL)

```bash
docker kill mycontainer
```

State: **exited**

---

## ❌ Remove it

```bash
docker rm mycontainer
```

State: **deleted**

---

### 🔍 Concept

`docker stop` gracefully terminates a container and moves it to the exited state, while `docker pause` freezes the container’s processes without stopping it, allowing it to be resumed later using `docker unpause`.

---

# Task 4: Working with Running Containers

## ▶️ Run an Nginx container in detached mode

```bash
docker run -d nginx
```

---

## 📜 View logs

```bash
docker logs <container_id>/<container_name>
```

---

## 🔄 View real-time logs (follow mode)

```bash
docker logs -f <container_id>/<container_name>
```

---

## 🖥️ Exec into the container

```bash
docker exec -it <container_id>/<container_name> bash
```

---

## ▶️ Run a single command inside the container

```bash
docker exec <container_id>/<container_name> ls
```

---

## 🔍 Inspect the container

```bash
docker inspect <container_name>/<container_id>
```

### Get specific details:

```bash
docker inspect mycontainer --format '{{.NetworkSettings.IPAddress}}'
docker inspect mycontainer --format '{{.NetworkSettings.Ports}}'
docker inspect mycontainer --format '{{.Mounts}}'
```

---

# Task 5: Cleanup

## ⛔ Stop all running containers

```bash
docker stop $(docker ps -q)
```

* `docker ps -q` → gives only container IDs
* `-a` includes stopped containers

---

## ❌ Remove all stopped containers

```bash
docker rm $(docker ps -aq)
```

* `-q` → only IDs
* `-a` → include all (stopped containers)

---

## 🧹 Remove unused images

```bash
docker image prune
```

---

## 💀 Remove all images (force)

```bash
docker rmi $(docker images -q)
```

---

## 💽 Check Docker disk usage

```bash
docker system df
```

---
