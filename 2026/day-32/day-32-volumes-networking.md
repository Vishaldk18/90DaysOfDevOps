Task 1: The Problem
docker run -d -e MYSQL_ROOT_PASSWORD=root mysql:8.0
docker exec -it fa3db7b485f8 bash
data is not persist when a volume is not attached to the container

Task 2: Named Volumes
docker run -d -e MYSQL_ROOT_PASSWORD=root -v mysql-data:/var/lib/mysql mysql:8.0
docker exec -it fa3db7b485f8 bash

Task 3: Bind Mounts
