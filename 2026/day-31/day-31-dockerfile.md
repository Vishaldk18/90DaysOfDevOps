Task 1: Your First Dockerfile
FROM ubuntu

RUN apt-get update && apt-get install -y curl

CMD ["echo", "Hello from my custom image!"]

docker run my-ubuntu:v1

Task 2: Dockerfile Instructions
FROM python:3.14

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

EXPOSE 8000

CMD ["python", "main.py"]


## 🔹 FROM — Base Image

The `FROM` instruction specifies the base image on which the Docker image is built. It is always the first instruction in a Dockerfile and defines the starting environment for the container.

A base image can be:
- A minimal OS (e.g., alpine, ubuntu)
- A runtime image (e.g., python, node)
- A custom image

Example:
```dockerfile
FROM ubuntu
````

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
* Multiple commands should be combined using `&&` to reduce layers

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
* Improves readability and structure

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

* It does NOT publish the port
* It acts as documentation for users and tools
* Used by Docker networking and orchestration tools

To actually expose the port externally:

```bash
docker run -p 8000:8000 image_name
```

Purpose:

* Document application port
* Improve clarity for developers
* Assist container orchestration tools

---

## 🔹 CMD — Default Command

The `CMD` instruction specifies the default command that runs when a container starts.

Example:

```dockerfile
CMD ["python", "app.py"]
```

Key Points:

* Only one CMD is allowed (last one overrides previous)
* Can be overridden at runtime
* Should be written in JSON array format (exec form)

Shell form example:

```dockerfile
CMD python app.py
```

Exec form (recommended):

```dockerfile
CMD ["python", "app.py"]
```

Purpose:

* Define container startup behavior
* Specify the main application process
* Provide default execution logic

---

## 🧠 Summary

* FROM → Defines base image
* RUN → Executes commands during build
* COPY → Adds files to the image
* WORKDIR → Sets working directory
* EXPOSE → Documents the port
* CMD → Defines default runtime command

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

This example:

* Uses Python base image
* Sets working directory
* Copies application code
* Installs dependencies
* Documents port
* Runs the application

---
```


Task 3: CMD vs ENTRYPOINT

FROM alpine

CMD ["echo", "Hello"]

docker run demo1

docker run demo1 echo test

FROM alpine

ENTRYPOINT ["echo"]

docker run demo2

docker run demo2 test


CMD is used to provide a default command that can be overridden at runtime, while ENTRYPOINT is used to define a fixed command that always runs, with any additional arguments appended to it. In practice, ENTRYPOINT is used for fixed executables and CMD for default arguments.
