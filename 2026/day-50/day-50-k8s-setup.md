# Kubernetes Notes

## Why was Kubernetes created? What problem does it solve that Docker alone cannot?

Kubernetes was created by Google to manage their applications and increasing load on the servers.

Kubernetes solves problems related to **scaling and healing**.

With Kubernetes you can:

* Auto scale
* Auto heal

---

## Who created Kubernetes and what was it inspired by?

Kubernetes was created by Google engineers **Joe Beda, Brendan Burns, and Craig McLuckie in 2014** to manage and orchestrate containers at scale.

It was inspired by Google’s internal cluster management systems **Borg and later Omega**, which were used to run containers across thousands of machines.

Kubernetes adopted key concepts from Borg such as:

* Cluster management
* Container scheduling
* Self-healing
* Declarative configuration
* Auto-scaling

Google later open-sourced Kubernetes and donated it to the **Cloud Native Computing Foundation (CNCF) in 2015**, where it is now maintained by the community.

---

## What does the name "Kubernetes" mean?

Kubernetes comes from a Greek word meaning **“helmsman” or “pilot”**, representing a system that steers and manages containerized applications.

---

# Kubernetes Architecture

## kubectl

`kubectl` is a command-line tool used to interact with the Kubernetes API server to manage cluster resources such as:

* Pods
* Deployments
* Services
* Ingress

---

## Master Node / Control Plane

### API Server

* The front door to the cluster
* Every command goes through it
* Receives requests from kubectl and other components
* Coordinates communication between cluster components

---

### Scheduler

* Watches for newly created pods without a node assigned
* Decides which worker node the pod should run on
* Uses available resources for decision making

---

### etcd

* Distributed key-value database
* Stores entire cluster state including:

  * Configuration
  * Secrets
  * Cluster data

---

### Controller Manager

* Continuously monitors the cluster state
* Ensures desired state matches actual state

---

## Worker Node

### kubelet

* Agent running on every worker node
* Communicates with API server
* Ensures containers in pods are running and healthy

---

### kube-proxy (Service Proxy)

* Handles networking rules
* Enables communication between services and pods
* Manages networking rules on worker nodes

---

### Container Runtime

* Engine that runs containers
* Examples:

  * containerd
  * CRI-O
* Responsible for running containers on worker nodes

---

### CNI (Container Network Interface)

* Provides networking for Kubernetes pods
* Enables communication between pods across nodes

---
---

# 1️⃣ What happens when you run `kubectl apply -f pod.yaml`?

### Step-by-step request flow

1️⃣ **kubectl command**

You run:

```bash
kubectl apply -f pod.yaml
```

* `kubectl` reads the YAML file
* Sends a **REST API request** to the **API Server**

---

2️⃣ **API Server**

The **API Server** is the entry point of Kubernetes.

It performs:

* **Authentication** → who is making the request
* **Authorization** → are they allowed
* **Validation** → is YAML valid

If valid → request proceeds.

---

3️⃣ **etcd**

The **API Server stores the desired state** in **etcd**.

Example stored data:

```
Pod name
Container image
Resources
Labels
Node assignment (initially none)
```

Now Kubernetes knows:

> “A pod should exist.”

---

4️⃣ **Scheduler**

The **Scheduler watches the API server** for **pods without a node assigned**.

It decides **which worker node should run the pod** based on:

* CPU
* Memory
* Node availability
* Scheduling rules

Then it **updates the pod with the chosen node** via API Server.

---

5️⃣ **Kubelet (Worker Node)**

The **kubelet on the selected node sees the pod assignment** from the API Server.

Then it:

* Talks to **container runtime**

Example:

```
containerd
CRI-O
```

---

6️⃣ **Container Runtime**

The container runtime:

* Pulls the image from registry
* Starts the container
* Runs it inside a **pod**

---

7️⃣ **kube-proxy + CNI networking**

Now networking is configured:

* **CNI** gives the pod an IP
* **kube-proxy** configures service routing

Pod is now **Running**.

---

✅ **Simple flow**

```
kubectl
   ↓
API Server
   ↓
etcd (store state)
   ↓
Scheduler (choose node)
   ↓
Kubelet (worker node)
   ↓
Container Runtime
   ↓
Pod starts
```

---

# 2️⃣ What happens if the API Server goes down?

The **API Server is the brain communication hub**.

If it goes down:

### What stops working

* `kubectl` commands
* Creating new pods
* Scaling deployments
* Updating resources
* Scheduler decisions
* Controllers updating state

Because **all components talk through the API server**.

---

### What keeps working

Existing workloads **continue running**.

Example:

```
Running pods stay running
Applications keep serving traffic
```

Why?

Because:

* kubelet already started containers
* container runtime keeps them running

---

### In production clusters

There are **multiple API servers** behind a **load balancer** for **high availability**.

---

# 3️⃣ What happens if a worker node goes down?

Example:

```
Node-2 crashes
```

### Step 1 — Node becomes NotReady

The **Node Controller** in control plane detects:

```
kubelet heartbeat stopped
```

Node status:

```
NotReady
```

---

### Step 2 — Pods marked unhealthy

After a timeout (~40 seconds default):

Pods on that node become:

```
Unknown / NotReady
```

---

### Step 3 — Controller reacts

If the pods are managed by:

* Deployment
* ReplicaSet
* StatefulSet

Kubernetes creates **replacement pods on other nodes**.

Example:

```
3 replicas required
1 node died
2 pods alive
Controller creates 1 new pod
```

---

### Step 4 — Scheduler schedules new pod

Scheduler assigns the replacement pod to another healthy node.

---

### Final Result

The cluster **self-heals automatically**.

This is Kubernetes **self-healing capability**.

---

# 🧠 Quick Interview Summary

### kubectl apply flow

```
kubectl → API Server → etcd → Scheduler → Kubelet → Container Runtime → Pod runs
```

---

### If API Server fails

* Cluster **cannot accept new commands**
* Existing pods **continue running**

---

### If worker node fails

* Node becomes **NotReady**
* Pods are **rescheduled to other nodes**
* Cluster **self-heals**

---


Task 3: Install kubectl
kubectl is the CLI tool you will use to talk to your Kubernetes cluster.
# Linux (amd64)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

Verify:
kubectl version --client


Task 4: Set Up Your Local Cluster
Option A: kind (Kubernetes in Docker)
# Linux
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Create a cluster
kind create cluster --name devops-cluster

# Verify
kubectl cluster-info
kubectl get nodes


Option B: minikube
# Start a cluster
minikube start

# Verify
kubectl cluster-info
kubectl get nodes


Task 5: Explore Your Cluster
Now that your cluster is running, explore it:

# See cluster info
kubectl cluster-info

# List all nodes
kubectl get nodes

# Get detailed info about your node
kubectl describe node <node-name>

# List all namespaces
kubectl get namespaces

# See ALL pods running in the cluster (across all namespaces)
kubectl get pods -A


Task 6: Practice Cluster Lifecycle
Build muscle memory with cluster operations:

# Delete your cluster
kind delete cluster --name devops-cluster
# (or: minikube delete)

# Recreate it
kind create cluster --name devops-cluster
# (or: minikube start)

# Verify it is back
kubectl get nodes


Try these useful commands:

# Check which cluster kubectl is connected to
kubectl config current-context

# List all available contexts (clusters)
kubectl config get-contexts

# See the full kubeconfig
kubectl config view


What is a kubeconfig? Where is it stored on your machine?
A kubeconfig is a configuration file used by kubectl to connect to and manage Kubernetes clusters. It contains information about clusters, users (credentials), and contexts (cluster + user + namespace).
By default, the kubeconfig file is stored at:
~/.kube/config
kubectl reads this file to know which cluster to communicate with and which credentials to use when executing Kubernetes commands.





