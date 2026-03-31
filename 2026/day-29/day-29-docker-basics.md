Task 1
What is Docker?
docker is containerization platform that lets you build applications, pakage them with all dependecies and runs them anywhere consistently.

why docker?
No “works on my machine” problem
Fast deployment
Lightweight compared to VMs

what is container?
a container is  lightweight, standalone executable package that includes application code, runtime, libraries, dependencies

Why Do We Need Containers?
Without containers 😵:
App works on dev machine ❌ fails on server
Dependency conflicts
Different OS issues

With containers 🚀:
Same environment everywhere
Easy CI/CD
Fast startup
Isolation between apps
👉 Key Idea: Consistency + Portability

⚔️ Containers vs Virtual Machines (IMPORTANT)
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


Docker architecture
1) Docker client: docker client is the interface through which user interact with docker, uses commands like docker run, docker build, docker pull. sends request to docker daemon using rest API

2) Docker Daemon (dockerd): dockerd is the core component of docker responsible for building docker images, running containers, managing networks and volumes. It listens to Docker API requests and processes them.

3) Docker Images: are read-only templates/blueprint used to create containers. it contain application code, dependencies, libraries and os layers. Built using dockerfile

4) Docker Container: Running instance of a docker image. it is lightweith, shares host os kernerl, can be started,stopped & deleted.
Image = Blueprint
Container = Running application

5) Docker Registery: stores docker images. used to push and pull images
Public Registry: Docker Hub
Private Registry:
AWS ECR
Google Container Registry

User runs a command using Docker Client
Client sends request to Docker Daemon
Daemon checks if image exists locally
If not, pulls image from Registry
Daemon creates and runs container from image


User → Docker Client → Docker Daemon → Docker Image → Container
                                   ↓
                              Docker Registry

