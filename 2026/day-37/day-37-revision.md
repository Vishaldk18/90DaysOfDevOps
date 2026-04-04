# 🐳 Docker Interview Q&A

---

## 1. What is the difference between an image and a container?

* **Image**: A read-only template that contains application code, dependencies, and environment.
* **Container**: A running instance of that image.

👉 *Image = blueprint, Container = running app*

---

## 2. What happens to data inside a container when you remove it?

* Data is **lost permanently** ❌
* Containers are **ephemeral**

👉 To persist data:

* Use **volumes** or **bind mounts**

---

## 3. How do two containers on the same custom network communicate?

* Docker provides **built-in DNS**
* Containers communicate using **container names**

👉 Example:

* Container `app2` can call `http://app1`

---

## 4. What does `docker compose down -v` do differently from `docker compose down`?

* `docker compose down`:

  * Removes containers and networks

* `docker compose down -v`:

  * Removes containers + networks + **volumes (data deleted)** ❌

---

## 5. Why are multi-stage builds useful?

* Separate **build stage** and **runtime stage**
* Remove:

  * build tools
  * caches
  * unnecessary files

👉 Result:

* Smaller image
* Better security
* Faster deployments

---

## 6. What is the difference between COPY and ADD?

* **COPY**:

  * Copies files from local → container
  * Simple and preferred ✅

* **ADD**:

  * Can also:

    * extract tar files
    * download from URLs

👉 Best practice: **Use COPY unless ADD features are needed**

---

## 7. What does `-p 8080:80` mean?

```bash
docker run -p 8080:80 nginx
```

* Maps:

  * **Host port 8080 → Container port 80**

👉 Access via:
`http://localhost:8080`

---

## 8. How do you check how much disk space Docker is using?

```bash
docker system df
```

👉 Shows:

* Images size
* Containers size
* Volumes size
* Build cache

---

## 🔥 One-Line Revision

* Image = template, Container = running instance
* Container data is temporary unless volumes used
* Same network → use container name
* `down -v` → deletes volumes
* Multi-stage → smaller + secure images
* COPY > ADD (preferred)
* `-p` → port mapping
* `docker system df` → disk usage

---
