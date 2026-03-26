# 🚀 What is Helm?

> Helm is a **package manager for Kubernetes** that helps you define, install, and manage applications using reusable templates called charts.

👉 Instead of writing multiple YAML files manually, Helm lets you **parameterize and reuse configurations**

---

# 📌 Three Core Concepts of Helm

## 1️⃣ Chart

* A **Helm package**
* Contains all Kubernetes YAML templates

👉 Example:

```
nginx-chart/
```

---

## 2️⃣ Release

* A **running instance of a chart** in a cluster

👉 Example:

```bash
helm install my-nginx bitnami/nginx
```

* `my-nginx` = release name
* `bitnami/nginx` = chart

---

## 3️⃣ Repository

* A **collection of charts**

👉 Example:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

---

# 🎯 Interview One-Liner

> Helm consists of Charts (templates), Releases (deployed instances), and Repositories (chart storage).

---

# ⚙️ Helm Lifecycle Commands

## 📦 Install

```bash
helm install my-app bitnami/nginx
```

---

## 🛠️ Customize

### Option 1: Using `--set`

```bash
helm install my-app bitnami/nginx --set replicaCount=3
```

### Option 2: Using values file

```bash
helm install my-app bitnami/nginx -f values.yaml
```

---

## 🔄 Upgrade

```bash
helm upgrade my-app bitnami/nginx -f values.yaml
```

👉 Applies new configuration

---

## ⏪ Rollback

```bash
helm rollback my-app 1
```

👉 Reverts to revision 1

---

## 📊 Check History

```bash
helm history my-app
```

---

# 📁 Structure of a Helm Chart

```text
my-chart/
│
├── Chart.yaml        # Metadata (name, version)
├── values.yaml       # Default values
├── charts/           # Dependencies
├── templates/        # Kubernetes YAML templates
│   ├── deployment.yaml
│   ├── service.yaml
│   └── _helpers.tpl
└── .helmignore
```

---

# 🧠 How Go Templating Works

Helm uses **Go templating engine** to make YAML dynamic.

---

## 🔹 Example Template

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}
spec:
  replicas: {{ .Values.replicaCount }}
```

---

## 🔹 values.yaml

```yaml
replicaCount: 3
service:
  type: NodePort
resources:
  requests:
    cpu: "200m"
    memory: "256Mi"
```

---

## 🔍 Final Output (Rendered YAML)

```yaml
metadata:
  name: my-app
spec:
  replicas: 2
```

---

## 🔑 Key Template Objects

| Object          | Meaning                 |
| --------------- | ----------------------- |
| `.Values`       | Values from values.yaml |
| `.Release.Name` | Release name            |
| `.Chart.Name`   | Chart name              |

---

# 🧠 Easy Memory Trick

👉 **"Chart → Release → Repo"**
👉 **"Template + Values = Final YAML"**

---

# 🚀 Pro Tips (Impress Interviewer)

* Helm enables **DRY (Don’t Repeat Yourself)** in Kubernetes
* Supports **versioning and rollback**
* Uses **Go templating for dynamic configs**
* Helps in **CI/CD automation**

---

# 🎯 Final Interview Answer (Compact)

> Helm is a Kubernetes package manager that uses charts to define applications. A chart is a collection of templates, a release is a deployed instance of a chart, and repositories store charts. Helm supports installing, upgrading, and rolling back applications, and uses Go templating to dynamically generate Kubernetes manifests using values from a values.yaml file.

---

# 🚀 Helm Commands Cheat Sheet

---

# 📦 Repository Management

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo list
helm repo update
helm repo remove bitnami
```

---

# 🔍 Searching Charts

```bash
helm search repo nginx
helm search hub nginx
```

---

# 📄 View Chart Info

```bash
helm show chart bitnami/nginx
helm show values bitnami/nginx
helm show readme bitnami/nginx
```

---

# 📥 Install Releases

```bash
helm install my-app bitnami/nginx
```

### With custom values

```bash
helm install my-app bitnami/nginx -f values.yaml
```

### With inline override

```bash
helm install my-app bitnami/nginx --set replicaCount=3
```

---

# 📋 List Releases

```bash
helm list
helm list -A
helm list -q
```

---

# 🔎 Get Release Details

```bash
helm get all my-app
helm get values my-app
helm get values my-app --all
helm get manifest my-app
```

---

# 🔄 Upgrade Releases

```bash
helm upgrade my-app bitnami/nginx
```

### With new config

```bash
helm upgrade my-app bitnami/nginx -f values.yaml
```

---

# ⏪ Rollback

```bash
helm history my-app
helm rollback my-app 1
```

---

# ❌ Uninstall

```bash
helm uninstall my-app
```

### All releases (current namespace)

```bash
helm uninstall $(helm list -q)
```

---

# 🧪 Dry Run & Debug

```bash
helm install my-app bitnami/nginx --dry-run --debug
helm upgrade my-app bitnami/nginx --dry-run --debug
```

---

# 📂 Create & Work with Charts

```bash
helm create my-chart
helm lint my-chart
helm package my-chart
helm install my-chart-release ./my-chart
```

---

# 🧩 Template Rendering

```bash
helm template my-app bitnami/nginx
```

👉 Shows generated YAML without deploying

---

# 📦 Dependencies

```bash
helm dependency update
helm dependency build
```

---

# 🔐 Helm Version

```bash
helm version
```

---

# 🎯 Most Important Commands (Interview Focus 🔥)

```bash
helm install
helm upgrade
helm rollback
helm uninstall
helm list
helm history
helm get values
helm show values
```

---

# 🧠 Easy Memory Trick

👉 **"Repo → Install → List → Get → Upgrade → Rollback → Delete"**

---

# 🚀 Pro Tips (Real DevOps)

* Always use `--dry-run --debug` before deploying
* Use `values.yaml` instead of too many `--set`
* Use `helm template` to debug YAML
* Use `helm history` before rollback

---

# 🎤 Interview One-Liner

> Helm commands help manage the full lifecycle of Kubernetes applications including installing, upgrading, rolling back, and inspecting releases.

---
