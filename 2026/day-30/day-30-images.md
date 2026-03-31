Task 1: Docker Images
docker pull alpine
docker pull nginx
docker pull ubuntu

docker image ls

ubuntu vs alpine — why is one much smaller?
Alpine is much smaller than Ubuntu because it is a minimal Linux distribution that uses musl libc and BusyBox, 
includes only essential components, and avoids unnecessary packages, whereas Ubuntu is a full-featured OS with 
glibc and many pre-installed utilities, making it larger.

Inspect an image — what information can you see?
Shows detailed JSON metadata about the image
Helps you understand:
Layers
Environment variables
Entrypoint / CMD
OS & architecture
Size and config


Task 2: Image Layers
Run docker image history nginx — what do you see?
docker image history shows the layer-by-layer history of a Docker image, including the commands used to create each layer and their sizes, which helps in understanding and optimizing the image.

What are Docker Layers?
Layers are the building blocks of a Docker image
Docker layers are read-only filesystem layers created for each instruction in a Dockerfile. 
Docker uses layers to enable efficient storage, caching, faster builds, and reuse across images, making containers lightweight and performant.

Every instruction in a Dockerfile creates a new layer
Layers are:
Read-only
Stacked on top of each other

Example
FROM ubuntu
RUN apt-get update
RUN apt-get install nginx
COPY . /app
CMD ["nginx"]

Layer 1 → Ubuntu base
Layer 2 → apt-get update
Layer 3 → install nginx
Layer 4 → copy files
Layer 5 → CMD

Task 3: Container Lifecycle
Create a container (without starting it)
docker create --name mycontainer nginx
state: created

Start the container
docker start mycontainer
state: up/running

Pause it (Freezes container processes (CPU stopped))
docker pause mycontainer
state: paused

Unpause it
docker unpause mycontainer
state: up/running

Stop it (graceful (SIGTERM))
docker stop mycontainer
state: exited

Restart it
docker restart mycontainer
state: up/running

Kill it (force (SIGKILL))
docker kill mycontainer (force stop)
state: exited

Remove it
docker rm mycontainer
state: deleted

docker stop gracefully terminates a container and moves it to the exited state, while docker pause freezes the container’s processes without stopping it, allowing it to be resumed later using docker unpause.

Task 4: Working with Running Containers
Run an Nginx container in detached mode
docker run -d nginx

View its logs
docker logs <containerid>/<containerName>

View real-time logs (follow mode)
docker logs -f <containerid>/<containerName>

Exec into the container and look around the filesystem
docker exec -it <containerid>/<containerName> bash

Run a single command inside the container without entering it
docker exec <containerid>/<containerName> ls

Inspect the container — find its IP address, port mappings, and mounts
docker inspect <container_name>/<containerid>

docker inspect mycontainer --format '{{.NetworkSettings.IPAddress}}'
docker inspect mycontainer --format '{{.NetworkSettings.Ports}}'
docker inspect mycontainer --format '{{.Mounts}}'

Task 5: Cleanup
Stop all running containers in one command
docker stop $(docker ps -q)

docker ps -q → gives only container IDs
-a includes stopped containers

Remove all stopped containers in one command
docker rm $(docker ps -aq)
-q → only IDs
-a → include all (stopped containers)

Remove unused images
docker image prune
Remove all images (force)
docker rmi $(docker image ls)

Check how much disk space Docker is using
docker system df
