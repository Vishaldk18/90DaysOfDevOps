# 🧪 Kubernetes Practice Tasks

---

# 📌 Task 1

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
    resources:
      requests:
        cpu: "100m"
        memory: "128Mi"
      limits:
        cpu: "150m"
        memory: "256Mi"
```

Kubernetes QoS classes define how Pods are prioritized during resource contention. There are three classes:

* Guaranteed: requests = limits → highest priority
* Burstable: requests ≠ limits → medium priority
* BestEffort: no requests/limits → lowest priority

During resource pressure, Pods are evicted in the order:
**BestEffort → Burstable → Guaranteed**

---

# 📌 Task 2

```yaml
kind: Pod
apiVersion: v1
metadata:
 name: oom-demo
spec:
  containers:
  - name: oom-demo
    image: polinux/stress
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "200M", "--vm-hang", "1"]
    resources:
      limits:
        memory: "100Mi"
```

This Pod is in a CrashLoopBackOff state because the container is exceeding its memory limit. The stress container tries to allocate 200MB of memory, but the limit is set to 100Mi. As a result, the container is terminated with an OOMKilled error. Kubernetes then restarts the container, but since the issue persists, it enters a CrashLoopBackOff state.

| Term             | Meaning                                 |
| ---------------- | --------------------------------------- |
| OOMKilled        | Container killed due to memory limit    |
| CrashLoopBackOff | Container keeps crashing and restarting |

---

# 📌 Task 3

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: nginx2
spec:
  containers:
  - name: nginx2
    image: nginx:latest
    ports:
    - containerPort: 80
    resources:
      requests:
        cpu: "100"
        memory: "128Gi"
```

This Pod is in Pending state because the scheduler cannot find a node with sufficient resources. The Pod is requesting 100 CPU cores and 128GB of memory, which exceeds the available resources of the node. Therefore, the scheduler fails with an "Insufficient CPU and memory" error, and the Pod is not scheduled.

---

# 📌 Task 4

Liveness probes do not wait for the application to be ready — they only check if it is alive. Misconfigured liveness probes can cause unnecessary restarts.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-liveness
spec:
  containers:
  - name: busybox-liveness
    image: busybox:1.27.2
    args:
      - /bin/sh
      - -c
      - |
        touch /tmp/healthy
        sleep 30
        rm -f /tmp/healthy
        while true; do sleep 5; done
    livenessProbe:
      exec:
        command:
          - cat
          - /tmp/healthy
      periodSeconds: 5
      failureThreshold: 3
```

---

# 📌 Task 5

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-readiness
  labels:
    app: nginx-readiness
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
      - containerPort: 80
    readinessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 5
```

A readiness probe determines whether a Pod is ready to receive traffic. If the probe fails, Kubernetes removes the Pod from the Service endpoints, but does not restart the container. This ensures traffic is only sent to healthy Pods.

---

# 📌 Task 6

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: startup-liveness-demo
spec:
  containers:
  - name: app
    image: busybox
    command:
      - sh
      - -c
      - |
        echo "Starting app..."
        sleep 20
        touch /tmp/started
        echo "App started"
        while true; do sleep 5; done

    # ✅ Startup Probe (runs first)
    startupProbe:
      exec:
        command:
          - cat
          - /tmp/started
      periodSeconds: 5
      failureThreshold: 12

    # ✅ Liveness Probe (waits until startupProbe succeeds)
    livenessProbe:
      exec:
        command:
          - cat
          - /tmp/started
      periodSeconds: 5
```

A startup probe can restart a container if it fails repeatedly beyond the configured failureThreshold. It is designed to give slow-starting applications enough time to initialize. During this phase, liveness probes are disabled. Once the startup probe succeeds, liveness probes take over.

---

## 📊 Probe Summary

| Probe Type | Can Restart? | When                         |
| ---------- | ------------ | ---------------------------- |
| Startup    | ✅ Yes        | If app doesn’t start in time |
| Liveness   | ✅ Yes        | If app becomes unhealthy     |
| Readiness  | ❌ No         | Only removes from traffic    |

---
