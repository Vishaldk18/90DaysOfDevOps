# Kubernetes ConfigMaps & Secrets - Complete Notes

---

## Task 1: Create ConfigMap from Literal

```bash
kubectl create configmap app-config \
  --from-literal=ENV=production \
  --from-literal=DEBUG=false
````

---

## Task 2: Create ConfigMap from File

### nginx.conf

```nginx
server {
  listen 80;

  location / {
      return 200 "Welcome to Nginx!\n";
  }

  location /health {
      default_type text/plain;
      return 200 "healthy\n";
  }
}
```

### Create ConfigMap

```bash
kubectl create configmap nginx-config \
  --from-file=default.conf=nginx.conf
```

---

## Task 3: Use ConfigMap in Pod

### Using envFrom

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: busybox-pod
spec:
  containers:
  - name: busybox
    image: busybox:latest
    command: ["sh", "-c"]
    args:
     - printenv && sleep 3600
    envFrom:
    - configMapRef:
       name: app-config
```

---

### Mount ConfigMap as Volume (Nginx)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
    volumeMounts:
    - name: nginx-config
      mountPath: /etc/nginx/conf.d
  volumes:
  - name: nginx-config
    configMap:
      name: nginx-config
```

---

## Task 4: Create Secret

```bash
kubectl create secret generic db-credentials \
  --from-literal=DB_USER=admin \
  --from-literal=DB_PASSWORD=s3cureP@ssw0rd
```

---

## Task 5: Use Secret in Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: db-pod
spec:
  containers:
    - name: db-container
      image: mysql
      ports:
        - containerPort: 3306

      # Inject single env variable from Secret
      env:
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: username

      # Mount full Secret as files
      volumeMounts:
        - name: db-secret-volume
          mountPath: /etc/db-credentials
          readOnly: true

  volumes:
    - name: db-secret-volume
      secret:
        secretName: db-credentials
```

---

## Task 6: ConfigMap Live Update (Volume)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: live-config-pod
spec:
  containers:
    - name: busybox
      image: busybox
      command: ["/bin/sh", "-c"]
      args:
        - |
          while true; do
            echo "Current message:";
            cat /etc/config/message;
            sleep 5;
          done
      volumeMounts:
        - name: config-volume
          mountPath: /etc/config

  volumes:
    - name: config-volume
      configMap:
        name: live-config
```

---

# Concepts (Interview Ready)

---

## 1. ConfigMap vs Secret

### ConfigMap

* Stores non-sensitive configuration
* Plain text

**Examples:**

* ENV variables
* URLs
* Feature flags

---

### Secret

* Stores sensitive data
* Base64 encoded

**Examples:**

* DB passwords
* API keys
* TLS certs

---

### When to Use

| Use Case       | ConfigMap | Secret |
| -------------- | --------- | ------ |
| App config     | ✅         | ❌      |
| DB credentials | ❌         | ✅      |
| Feature flags  | ✅         | ❌      |
| API keys       | ❌         | ✅      |

---

## 2. Env Variables vs Volume Mounts

### Environment Variables

```yaml
env:
  - name: DB_USER
    valueFrom:
      secretKeyRef:
        name: db-secret
        key: username
```

* Loaded at startup
* Easy to use
* ❌ Not dynamic

---

### Volume Mounts

```yaml
volumeMounts:
  - name: config-vol
    mountPath: /etc/config
```

* Data as files
* ✅ Dynamic updates

---

### Difference

| Feature        | Env Vars  | Volume  |
| -------------- | --------- | ------- |
| Format         | Key-value | Files   |
| Dynamic update | ❌         | ✅       |
| Use case       | Simple    | Dynamic |

---

## 3. Base64 Encoding vs Encryption

### Base64

```bash
echo "admin" | base64
# YWRtaW4=

echo "YWRtaW4=" | base64 --decode
# admin
```

* Easily reversible
* ❌ Not secure

---

### Encryption

* Requires key
* Secure

---

### Key Point

Kubernetes Secrets:

* Base64 encoded
* Not secure unless:

  * Encryption at rest enabled
  * Proper RBAC used

---

## 4. ConfigMap Updates Behavior

### Volume Mount

* Auto updates (~30–60 sec)

```
/etc/config/message → updated automatically
```

---

### Environment Variables

* Static at startup

```
ENV=hello ❌ won't change
```

---

### Final Comparison

| Behavior       | Volume | Env |
| -------------- | ------ | --- |
| Auto update    | ✅      | ❌   |
| Restart needed | ❌      | ✅   |

---

## Final Interview Summary

* ConfigMap → non-sensitive config
* Secret → sensitive data
* Env → static
* Volume → dynamic
* Base64 → encoding, not encryption
* Volume updates → automatic
* Env updates → require restart

---
