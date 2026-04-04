# 🚀 Docker Tasks & Notes

---

# 🧩 Task 1: The Problem with Large Images

```dockerfile
FROM node:18

WORKDIR /app

COPY . .

CMD ["node", "app.js"]
````

**Single stage dockerfile size = around 1 GB**

---

# 🧩 Task 2: Multi-Stage Build

```dockerfile
# -------- Stage 1: Build --------

FROM node:18 AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

# -------- Stage 2: Runtime --------

FROM node:18-alpine

WORKDIR /app

COPY --from=builder /app /app

EXPOSE 3000

CMD ["node", "app.js"]
```

---

## ❓ Why is the multi-stage image so much smaller?

Multi-stage builds reduce image size by separating the build and runtime environments. The builder stage includes heavy tools like compilers, package managers, caches, and dev dependencies, which are removed in the final image. Only essential artifacts such as application code and production dependencies are copied into a minimal base image like Alpine. This results in a smaller, more secure, and efficient Docker image.

---

# 🧩 Task 3: Push to Docker Hub

```bash
docker login
docker tag sample-multi-stage vishaldk18/sample-node-app-multistage:latest
docker push vishaldk18/sample-node-app-multistage:latest
```

---

# 🧩 Task 5: Image Best Practices

```dockerfile
FROM node:18-alpine

RUN addgroup -S appgroup && adduser -S appuser

WORKDIR /app

COPY package*.json ./

RUN npm install --production

COPY . .

RUN chown -R appuser:appgroup /app

USER appuser

CMD ["node", "app.js"]
```

---

# 📘 Docker & Linux Flags Cheat Sheet

---

## 1. -S (System User / Group)

Used with `adduser` and `addgroup` in Alpine Linux.

### Example:

```
addgroup -S appgroup
adduser -S appuser
```

### Meaning:

* Creates a **system user/group**
* No login shell
* Used for applications/services (not humans)

### Why use:

* Improves security
* Lightweight user creation

---

## 2. -G (Assign Group)

Used with `adduser` to assign a group.

### Example:

```
adduser -S appuser -G appgroup
```

### Meaning:

* Adds user `appuser` to group `appgroup`

---

## 3. --production (npm install)

Used with Node.js dependency installation.

### Example:

```
npm install --production
```

### Meaning:

* Installs only `dependencies`
* Skips `devDependencies`

### Why use:

* Reduces image size
* Faster install
* Better for production

---

## 4. -R (Recursive)

Used with commands like `chown`, `chmod`.

### Example:

```
chown -R appuser:appgroup /app
```

### Meaning:

* Applies changes to:

  * directory
  * all subdirectories
  * all files inside

### Without -R:

* Only top-level directory is affected

---

## 5. apk add --no-cache (Alpine Package Install)

Used in Alpine Linux to install packages.

### Example:

```
RUN apk add --no-cache curl
```

### Meaning:

* Installs package without saving cache

### Why use:

* Keeps Docker image small
* Avoids unnecessary files

---

## 📝 Notes

* `apk` → Alpine Linux package manager
* Use `--no-cache` in Docker builds to optimize image size
* Do NOT install unnecessary packages in production images

---

## ⚡ Quick Summary

* `-S` → system user/group
* `-G` → assign group to user
* `--production` → install only production dependencies
* `-R` → recursive operation
* `apk add --no-cache` → install packages without cache (smaller image)

```
