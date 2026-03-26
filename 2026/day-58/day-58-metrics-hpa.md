## Task 1

```bash
minikube addons enable metrics-server
```

---

## Task 2

```bash
kubectl top nodes
kubectl top pods -A
kubectl top pods -A --sort-by=cpu
```

---

## Task 3

```yaml
kind: Deployment
apiVersion: apps/v1
metadata:
  name: apache-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: apache-app
  template:
    metadata:
      labels:
        app: apache-app
    spec:
      containers:
      - name: apache-app
        image: registry.k8s.io/hpa-example
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: "200m"
```

---

## Task 4

```bash
kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
kubectl get hpa
kubectl describe hpa php-apache
```

---

## Task 5

```bash
kubectl run load-generator --image=busybox:1.36 --restart=Never -- /bin/sh -c "while true; do wget -q -O- http://php-apache; done"
kubectl get hpa php-apache --watch
kubectl delete pod load-generator
kubectl delete hpa php-apache
```

---

## Task 6

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: php-apache
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: apache-app

  minReplicas: 1
  maxReplicas: 10

  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50

  behavior:
    scaleUp:
      stabilizationWindowSeconds: 0   # no stabilization (fast scale up)
      policies:
      - type: Percent
        value: 100
        periodSeconds: 15

    scaleDown:
      stabilizationWindowSeconds: 300  # wait 5 minutes before scaling down
      policies:
      - type: Percent
        value: 50
        periodSeconds: 60
```

---

## 🚀 What is Metrics Server?

> Metrics Server is a **cluster-wide aggregator of resource usage data (CPU & memory)** in Kubernetes.

👉 It collects metrics from:

```text
Kubelet → Metrics Server → Kubernetes API
```

---

## 🔥 Why HPA Needs Metrics Server

* HPA depends on **real-time CPU/memory usage**
* Metrics Server provides this data via:

```bash
kubectl top pods
kubectl top nodes
```

👉 Without Metrics Server:

```text
❌ No metrics → ❌ No scaling
```

---

## 🎯 Interview Answer

> Metrics Server provides resource usage metrics required by HPA. Without it, HPA cannot calculate utilization and therefore cannot scale Pods.

---

## 📊 How HPA Calculates Desired Replicas

### 🧠 Formula

```text
Desired Replicas = Current Replicas × (Current Metric / Target Metric)
```

---

### 🔍 Example

* Current Pods = 2
* CPU usage = 80%
* Target = 50%

```text
Desired = 2 × (80 / 50) = 3.2 → 4 Pods
```

👉 Kubernetes rounds up → **4 Pods**

---

### ⚡ Key Insight

👉 HPA compares:

```text
Actual usage vs Requested CPU
```

That’s why:

```text
CPU requests are mandatory 🔥
```

---

## 📦 autoscaling/v1 vs autoscaling/v2

### 🔹 autoscaling/v1

* Only supports:

  * CPU utilization ❗
* Simple configuration
* No advanced control

```yaml
targetCPUUtilizationPercentage: 50
```

---

### 🔹 autoscaling/v2 (Modern)

* Supports:

  * CPU ✅
  * Memory ✅
  * Custom metrics ✅
  * External metrics ✅

* Supports:

  * **behavior (scale up/down control)** 🔥

---

### ⚖️ Comparison Table

| Feature          | autoscaling/v1 | autoscaling/v2 |
| ---------------- | -------------- | -------------- |
| CPU metrics      | ✅              | ✅              |
| Memory metrics   | ❌              | ✅              |
| Custom metrics   | ❌              | ✅              |
| External metrics | ❌              | ✅              |
| Behavior control | ❌              | ✅              |
| Production ready | ❌              | ✅              |

---

## 🧠 Easy Memory Trick

👉 **"v1 = Basic, v2 = Advanced"**

---

## 🚀 Pro Tips (Impress Interviewer)

* Always use **autoscaling/v2 in production**
* Metrics Server is required for **resource metrics**
* For advanced scaling → use **Prometheus + custom metrics**

---

## 🎯 Final Interview Answer (Compact)

> Metrics Server collects resource usage data required by HPA. HPA calculates desired replicas based on the ratio of current usage to target utilization. autoscaling/v1 supports only CPU-based scaling, while autoscaling/v2 supports multiple metrics and advanced scaling behaviors, making it suitable for production use.

---
