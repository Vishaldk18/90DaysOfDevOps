# Kubernetes Services – Interview Notes

---

## 1. What problem do Services solve?

Kubernetes Services solve the problem of **dynamic Pod IPs**.

- Pods are **ephemeral** (can be created/destroyed anytime)
- Each Pod gets a new IP when recreated
- Direct communication with Pods is unreliable

### What Services provide:
- Stable **virtual IP (ClusterIP)**
- Stable **DNS name**
- Built-in **load balancing**

### Interview Answer:
> Kubernetes Services provide a stable endpoint and DNS name for a group of Pods, enabling reliable communication and load balancing despite dynamic Pod lifecycles.

---

## 2. Relation between Pods, Deployments, and Services

- **Deployment** → Manages Pods (scaling, updates)
- **Pods** → Run application containers
- **Service** → Exposes Pods using **label selectors**

### Flow:
```

Deployment → Pods → Service → Users / Other Services

````

### Important:
- Service connects to **Pods (via labels)**, NOT directly to Deployment

---

## 3. Service Manifests

### 3.1 ClusterIP (Default)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: ClusterIP
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
````

* Default type
* Used for **internal communication within cluster**

---

### 3.2 NodePort

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service-np
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080
```

* Exposes service on each node’s IP
* Port range: **30000–32767**

Access:

```
http://<NodeIP>:30080
```

---

### 3.3 LoadBalancer

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-lb-service
spec:
  type: LoadBalancer
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
```

* Used in **cloud environments (AWS, Azure, GCP)**
* Automatically creates an **external load balancer**
* Assigns public IP/DNS

---

## 4. Difference Between Service Types

| Type         | Scope    | Use Case                   |
| ------------ | -------- | -------------------------- |
| ClusterIP    | Internal | Microservice communication |
| NodePort     | External | Testing / basic access     |
| LoadBalancer | External | Production apps            |

---

## 5. Kubernetes DNS (Service Discovery)

Kubernetes uses **CoreDNS** for service discovery.

### DNS Format:

```
<service-name>.<namespace>.svc.cluster.local
```

### Example:

```
nginx-service.default.svc.cluster.local
```

Inside cluster, you can simply use:

```
curl http://nginx-service
```

### Flow:

```
Pod → DNS Query → CoreDNS → Service IP → Pod
```

---

## 6. What are Endpoints?

Endpoints represent the **actual Pod IPs behind a Service**.

* Service = frontend
* Endpoints = backend (real Pods)

### Check Endpoints:

```
kubectl get endpoints nginx-service
```

### Example Output:

```
NAME            ENDPOINTS
nginx-service   10.244.0.5:80,10.244.0.6:80
```

### Detailed View:

```
kubectl describe endpoints nginx-service
```

### Important:

* Service routes traffic → Endpoints
* If no endpoints → Service will not work

---

## 7. Final Interview Summary

> Kubernetes Services provide a stable IP and DNS name for Pods, enabling reliable communication and load balancing. They use label selectors to route traffic to Pods managed by Deployments. ClusterIP is used for internal communication, NodePort exposes services externally via node ports, and LoadBalancer provisions external access in cloud environments. Kubernetes DNS (CoreDNS) enables service discovery, and Endpoints represent the actual Pod IPs behind a Service.

---
