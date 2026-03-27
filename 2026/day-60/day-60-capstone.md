# 🚀 Kubernetes Capstone Project

---

## 🔹 Task 1: Namespace Setup

```bash
kubectl create namespace capstone
kubectl config set-context --current --namespace=capstone
```

---

## 🔹 Task 2: MySQL Setup

### 🔸 Secret (mysql-secret)

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
type: Opaque
stringData:
  MYSQL_ROOT_PASSWORD: rootpassword123
  MYSQL_DATABASE: mydatabase
  MYSQL_USER: myuser
  MYSQL_PASSWORD: mypassword123
```

### ❓ Why `stringData`?

* Allows writing **plain text values**
* Kubernetes automatically converts them to **base64**

---

### 🔸 Headless Service (mysql-headless)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql-headless
  namespace: capstone
spec:
  clusterIP: None
  selector:
    app: mysql
  ports:
    - port: 3306
      targetPort: 3306
```

### 🔍 What is a Headless Service?

**Normal Service:**

* Has a Cluster IP
* Load balances traffic

**Headless Service (`clusterIP: None`):**

* ❌ No cluster IP
* ❌ No load balancing
* ✅ Returns Pod IPs via DNS

👉 Used with **StatefulSets** for stable identity.

---

### 🔸 MySQL StatefulSet

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql-statefulset
  namespace: capstone
spec:
  selector:
    matchLabels:
      app: mysql
  serviceName: "mysql-headless"
  replicas: 1

  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        ports:
        - containerPort: 3306

        envFrom:
        - secretRef:
            name: mysql-secret

        resources:
          requests:
            cpu: "250m"
            memory: "512Mi"
          limits:
            cpu: "500m"
            memory: "1Gi"

        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql

  volumeClaimTemplates:
  - metadata:
      name: mysql-data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 1Gi
```

---

## 🔹 Task 3: WordPress Setup

### 🔸 ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: wordpress-config
data:
  WORDPRESS_DB_HOST: mysql-statefulset-0.mysql-headless.capstone.svc.cluster.local:3306
  WORDPRESS_DB_NAME: mydb
```

---

### 🔸 WordPress Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress-deployment
  namespace: capstone
spec:
  replicas: 2
  selector:
    matchLabels:
      app: wordpress

  template:
    metadata:
      labels:
        app: wordpress
    spec:
      containers:
      - name: wordpress
        image: wordpress:latest

        ports:
        - containerPort: 80

        envFrom:
        - configMapRef:
            name: wordpress-config

        env:
        - name: WORDPRESS_DB_USER
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: MYSQL_USER

        - name: WORDPRESS_DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: MYSQL_PASSWORD

        resources:
          requests:
            cpu: "250m"
            memory: "512Mi"
          limits:
            cpu: "500m"
            memory: "1Gi"

        livenessProbe:
          httpGet:
            path: /wp-login.php
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 10
          failureThreshold: 3

        readinessProbe:
          httpGet:
            path: /wp-login.php
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 5
          failureThreshold: 3
```

---

## 🔹 Task 4: WordPress Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: wordpress-service
  namespace: capstone
spec:
  type: NodePort
  selector:
    app: wordpress
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080
```

### 🔸 Access Commands

**Minikube:**

```bash
minikube service wordpress -n capstone
```

**Kind:**

```bash
kubectl port-forward svc/wordpress 8080:80 -n capstone
```

---

## 🔹 Task 5: Test Self-Healing & Persistence

* Delete pods → Kubernetes recreates them
* Check MySQL data persists via PVC

---

## 🔹 Task 6: Horizontal Pod Autoscaler (HPA)

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: wordpress-autoscaler
  namespace: capstone
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: wordpress-deployment

  minReplicas: 2
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
      stabilizationWindowSeconds: 0
      policies:
      - type: Percent
        value: 100
        periodSeconds: 15

    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 50
        periodSeconds: 60
```

---

# 🔥 Final Notes

* Use **StatefulSet** for databases (MySQL)
* Use **Deployment** for stateless apps (WordPress)
* Use **Headless Service** for stable DNS
* Use **ConfigMap + Secret** for configuration separation
* Use **HPA** for auto-scaling

---
