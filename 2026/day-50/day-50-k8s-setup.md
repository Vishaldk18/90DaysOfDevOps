Task 1

Why was Kubernetes created? What problem does it solve that Docker alone cannot?
kuberentes was created by google, to manage there applications and increasing load on the servers, k8s solves the problem related to scaling and healing
with k8s you can auto scale & auto heal

Who created Kubernetes and what was it inspired by?
Kubernetes was created by Google engineers Joe Beda, Brendan Burns, and Craig McLuckie in 2014 to manage and orchestrate containers at scale. It was inspired by Google’s internal cluster management systems Borg and later Omega, which were used to run containers across thousands of machines.
Kubernetes adopted key concepts from Borg such as cluster management, container scheduling, self-healing, declarative configuration, and auto-scaling. Google later open-sourced Kubernetes and donated it to the Cloud Native Computing Foundation (CNCF) in 2015, where it is now maintained by the community.


What does the name "Kubernetes" mean?
Kubernetes comes from a Greek word meaning “helmsman” or “pilot,” representing a system that steers and manages containerized applications.


Task 2
Draw the Kubernetes Architecture
From memory, draw or describe the Kubernetes architecture. Your diagram should include:

kubectl: kubectl is a command-line tool used to interact with the Kubernetes API server
to manage cluster resources such as pods, deployments, services, and ingress.

Master node/control plane
API Server: the front door to the cluster, every command goes through it. It receives
requests from kubectl and other components and coordinates communication
between cluster components. 
scheduler: The Scheduler watches for newly created pods that do not have a node assigned
and decides which worker node the pod should run on based on available resources.
etcd: etcd is a distributed key-value database that stores the entire state of
the Kubernetes cluster including configuration, secrets, and cluster data.
controller manager: ontinuously monitor the cluster
state and ensure the desired state matches the actual state.

Worker node
kubelet: kubelet is an agent that runs on every worker node. It communicates with the
API server and ensures containers in the pods are running and healthy.
service-proxy/kube-proxy : handles networking rules so pods can communicate, kube-proxy manages networking rules on worker nodes and enables communication
between services and pods inside the cluster.
Container Runtime: the engine that actually runs containers (containerd, CRI-O), Container Runtime is the software responsible for running containers
on worker nodes (example: containerd, CRI-O).

cni: CNI (Container Network Interface) provides networking for Kubernetes pods
and allows communication between pods across different nodes in the cluster.






These are **very common Kubernetes interview questions**. I'll explain them step-by-step in a **clear flow so you can remember the architecture**.

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

* Pulls container image
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




