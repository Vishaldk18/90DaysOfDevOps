---
# Task 1: Your First Dockerfile

```dockerfile
FROM ubuntu

RUN apt-get update && apt-get install -y curl

CMD ["echo", "Hello from my custom image!"]
````

```bash
docker run my-ubuntu:v1
```

---

# Task 2: Dockerfile Instructions

```dockerfile
FROM python:3.14

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

EXPOSE 8000

CMD ["python", "main.py"]
```

---

## 🔹 FROM — Base Image

The `FROM` instruction specifies the base image on which the Docker image is built. It is always the first instruction in a Dockerfile and defines the starting environment for the container.

A base image can be:

* A minimal OS (e.g., alpine, ubuntu)
* A runtime image (e.g., python, node)
* A custom image

Example:

```dockerfile
FROM ubuntu
```

You can also specify a version (tag):

```dockerfile
FROM python:3.9
```

Purpose:

* Provides the base filesystem
* Ensures consistency across environments
* Reduces setup effort

---

## 🔹 RUN — Execute Commands During Build

The `RUN` instruction executes commands during the image build process. It is typically used to install packages, update the system, or configure the environment.

Example:

```dockerfile
RUN apt-get update && apt-get install -y curl
```

Key Points:

* Each `RUN` creates a new layer
* Commands are executed at build time, not runtime
* Combine commands using `&&` to reduce layers

Example (optimized):

```dockerfile
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

Purpose:

* Install dependencies
* Prepare the environment
* Configure software inside the image

---

## 🔹 COPY — Copy Files from Host to Image

The `COPY` instruction copies files or directories from the host machine into the Docker image.

Example:

```dockerfile
COPY . /app
```

Syntax:

```dockerfile
COPY <source> <destination>
```

Key Points:

* Source is relative to the build context
* Destination is inside the container filesystem
* Supports copying multiple files

Example:

```dockerfile
COPY requirements.txt /app/
```

Purpose:

* Add application code
* Include configuration files
* Transfer dependencies into the image

---

## 🔹 WORKDIR — Set Working Directory

The `WORKDIR` instruction sets the working directory for all subsequent instructions such as RUN, CMD, ENTRYPOINT, COPY, and ADD.

Example:

```dockerfile
WORKDIR /app
```

Key Points:

* Automatically creates the directory if it does not exist
* Avoids using `cd` repeatedly
* Improves readability

Equivalent to:

```bash
cd /app
```

Purpose:

* Define a consistent working location
* Simplify command execution
* Organize application files

---

## 🔹 EXPOSE — Document the Port

The `EXPOSE` instruction informs Docker that the container listens on a specific network port at runtime.

Example:

```dockerfile
EXPOSE 8000
```

Key Points:

* Does NOT publish the port
* Acts as documentation
* Used by Docker networking tools

To expose externally:

```bash
docker run -p 8000:8000 image_name
```

Purpose:

* Document application port
* Improve clarity
* Assist orchestration tools

---

## 🔹 CMD — Default Command

The `CMD` instruction specifies the default command that runs when a container starts.

Example:

```dockerfile
CMD ["python", "app.py"]
```

Key Points:

* Only one CMD is used (last one wins)
* Can be overridden at runtime
* Prefer JSON (exec form)

Shell form:

```dockerfile
CMD python app.py
```

Exec form (recommended):

```dockerfile
CMD ["python", "app.py"]
```

Purpose:

* Define startup behavior
* Specify main process
* Provide default execution

---

## 🧠 Summary

* FROM → Base image
* RUN → Build-time commands
* COPY → Add files
* WORKDIR → Set directory
* EXPOSE → Document port
* CMD → Default command

---

## 🚀 Example Dockerfile

```dockerfile
FROM python:3.9

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

EXPOSE 8000

CMD ["python", "app.py"]
```

---

# Task 3: CMD vs ENTRYPOINT

```dockerfile
FROM alpine

CMD ["echo", "Hello"]
```

```bash
docker run demo1
docker run demo1 echo test
```

```dockerfile
FROM alpine

ENTRYPOINT ["echo"]
```

```bash
docker run demo2
docker run demo2 test
```

👉 CMD:

* Default command
* Can be overridden

👉 ENTRYPOINT:

* Fixed command
* Arguments are appended

---

# Task 4: Build a Simple Web App Image

## index.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My First Docker App</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            text-align: center;
            padding: 50px;
        }

        h1 {
            color: #2c3e50;
        }

        p {
            color: #555;
            font-size: 18px;
        }

        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            display: inline-block;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        button {
            padding: 10px 20px;
            border: none;
            background-color: #3498db;
            color: white;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>🚀 Hello from Docker!</h1>
    <p>This is my first containerized HTML app.</p>

    <button onclick="showMessage()">Click Me</button>
</div>

<script>
    function showMessage() {
        alert("🎉 Your Docker app is working!");
    }
</script>

</body>
</html>
```

---

## Dockerfile

```dockerfile
FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html
```

```bash
docker build -t web-app3 .
docker run -d -p 8080:80 web-app3
```

---

# Task 5 & 6

## ❌ Unoptimized Dockerfile

```dockerfile
FROM node:12.2.0-alpine

WORKDIR /app

COPY . .

RUN npm install

EXPOSE 8000

CMD ["node", "app.js"]
```

---

## ✅ Optimized Dockerfile

```dockerfile
FROM node:18-alpine

WORKDIR /app

# Copy only package files first (better caching)
COPY package*.json ./

RUN npm install

# Copy rest of the app
COPY . .

EXPOSE 8000

CMD ["node", "app.js"]
```

---

## 🧠 Explanation

We copy `package.json` separately to leverage Docker layer caching. Since dependencies change less frequently than application code, this prevents unnecessary reinstallation of dependencies and speeds up the build process.
