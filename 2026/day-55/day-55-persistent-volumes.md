# PVs are cluster-wide (not namespaced), PVCs are namespaced

---

# Task 1

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: demo-pod
spec:
  volumes:
  - name: pod-volume
    emptyDir: {}

  containers:
  - name: pod
    image: busybox
    command:
      - sh
      - -c
      - |
        while true; do
         echo "Message written at $(date)" >> /data/message.txt
         sleep 5
        done
    volumeMounts:
      - name: pod-volume
        mountPath: /data
````

---

# Task 2

```yaml
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /tmp/k8s-pv-data
```

---

# Task 3

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
```

---

# Task 4

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: demo-pod
spec:
  volumes:
  - name: pod-volume
    persistentVolumeClaim:
      claimName: pvc

  containers:
  - name: pod
    image: busybox
    command:
      - sh
      - -c
      - |
        while true; do
         echo "Message written at $(date)" >> /data/message.txt
         sleep 5
        done
    volumeMounts:
      - name: pod-volume
        mountPath: /data
```

---

# Task 5 & 6

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pvc2
spec:
  storageClassName: standard
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
```

---

# 📦 Why Containers Need Persistent Storage

## 🧠 Problem

Containers are **ephemeral**:

* When a container crashes or restarts → data is lost ❌
* New Pod = fresh filesystem ❌

---

## ✅ Why persistence is needed

👉 To store **important data outside the container lifecycle**

---

## 💡 Real Examples

* Database data (MySQL, PostgreSQL)
* User uploads (images, files)
* Logs that must survive restarts

---

## 🔥 Key Point

> Containers are temporary, but data is not.

---

# 🟢 What PVs and PVCs Are (and Relationship)

## 🔵 PersistentVolume (PV)

👉 A **cluster resource** representing actual storage

* Created by admin (or dynamically)
* Backed by:

  * AWS EBS
  * Disk
  * NFS

---

## 🟡 PersistentVolumeClaim (PVC)

👉 A **request for storage** by a user/Pod

---

## 🔗 Relationship

```text
Pod → PVC → PV → Real Storage
```

---

## 💡 Simple Analogy

* PV = **Water tank**
* PVC = **Tap request**
* Pod = **User drinking water**

---

## ✅ Flow

1. PVC requests storage
2. Kubernetes finds matching PV
3. PV binds to PVC
4. Pod uses PVC

---

# ⚙️ Static vs Dynamic Provisioning

## 🔴 Static Provisioning

### 📌 What it is

* Admin manually creates PV

---

### Flow:

1. Admin creates PV
2. User creates PVC
3. PVC binds to existing PV

---

### ❌ Problems

* Manual work
* Not scalable
* Hard to manage

---

## 🟢 Dynamic Provisioning

### 📌 What it is

* Kubernetes **automatically creates PV**

---

### Uses:

👉 **StorageClass**

---

### Flow:

1. PVC created
2. StorageClass triggers
3. PV automatically created
4. PVC binds

---

### ✅ Benefits

* Automated
* Scalable
* Used in real-world production

---

## 🔥 Interview Line

> “Dynamic provisioning uses StorageClasses to automatically create PersistentVolumes when a claim is made.”

---

# 🔐 Access Modes

👉 Define **how a volume can be mounted**

## 📊 Types

| Mode                | Meaning               | Example       |
| ------------------- | --------------------- | ------------- |
| ReadWriteOnce (RWO) | One node read/write   | AWS EBS       |
| ReadOnlyMany (ROX)  | Many nodes read-only  | Shared config |
| ReadWriteMany (RWX) | Many nodes read/write | NFS           |

---

## ⚠️ Important

* Depends on storage backend
* Not all support RWX (EBS does NOT)

---

# ♻️ Reclaim Policies

👉 What happens when PVC is deleted

## 📊 Types

| Policy  | Behavior                     |
| ------- | ---------------------------- |
| Retain  | Keep data (manual cleanup)   |
| Delete  | Delete storage automatically |
| Recycle | (deprecated)                 |

---

## 💡 Example

* `Retain` → safe for databases
* `Delete` → good for temporary apps

---

## ⚠️ Real-world insight

❗ Wrong reclaim policy = **data loss**

---

# 🧠 Final Interview Summary (Perfect Answer)

> “Containers are ephemeral, so persistent storage is needed to retain data across restarts. Kubernetes uses PersistentVolumes (PVs) to represent storage and PersistentVolumeClaims (PVCs) as requests for that storage. Pods use PVCs to access PVs. Storage can be provisioned statically by manually creating PVs or dynamically using StorageClasses. Access modes define how volumes can be mounted, and reclaim policies control what happens to storage after the claim is deleted.”

---

# 🚀 Pro DevOps Insight

| Scenario           | What to Use          |
| ------------------ | -------------------- |
| Database           | PVC + Retain         |
| Scalable apps      | Dynamic provisioning |
| Multi-node sharing | RWX (NFS/EFS)        |
| Temporary data     | Delete policy        |

---
