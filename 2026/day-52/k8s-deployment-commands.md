# 🚀 Day 52 – Kubernetes Namespaces & Deployments Cheat Sheet

## 🔹 Namespaces – Explore Default

```bash
kubectl get namespaces
kubectl get pods -n kube-system
````

---

## 🔹 Create Namespaces

```bash
kubectl create namespace dev
kubectl create namespace staging
kubectl get namespaces
```

---

## 🔹 Create Namespace using YAML

```bash
kubectl apply -f namespace.yaml
```

---

## 🔹 Run Pods in Specific Namespaces

```bash
kubectl run nginx-dev --image=nginx:latest -n dev
kubectl run nginx-staging --image=nginx:latest -n staging
```

---

## 🔹 View Pods Across Namespaces

```bash
kubectl get pods
kubectl get pods -A
kubectl get pods -n dev
kubectl get pods -n staging
```

---

## 🔹 Create Deployment

```bash
kubectl apply -f nginx-deployment.yaml
```

---

## 🔹 Check Deployment & Pods

```bash
kubectl get deployments -n dev
kubectl get pods -n dev
```

---

## 🔹 Self-Healing (Delete Pod)

```bash
kubectl get pods -n dev
kubectl delete pod <pod-name> -n dev
kubectl get pods -n dev
```

---

## 🔹 Scaling Deployment

```bash
kubectl scale deployment nginx-deployment --replicas=5 -n dev
kubectl get pods -n dev

kubectl scale deployment nginx-deployment --replicas=2 -n dev
kubectl get pods -n dev
```

---

## 🔹 Declarative Scaling

```bash
kubectl apply -f nginx-deployment.yaml
```

---

## 🔹 Rolling Update (Update Image)

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.25 -n dev
```

---

## 🔹 Check Rollout Status

```bash
kubectl rollout status deployment/nginx-deployment -n dev
```

---

## 🔹 Rollout History

```bash
kubectl rollout history deployment/nginx-deployment -n dev
```

---

## 🔹 Rollback Deployment

```bash
kubectl rollout undo deployment/nginx-deployment -n dev
kubectl rollout status deployment/nginx-deployment -n dev
```

---

## 🔹 Verify Image Version

```bash
kubectl describe deployment nginx-deployment -n dev | grep Image
```

---

## 🔹 View ReplicaSets

```bash
kubectl get replicasets -n dev
```

---

## 🔹 Cleanup Resources

```bash
kubectl delete deployment nginx-deployment -n dev
kubectl delete pod nginx-dev -n dev
kubectl delete pod nginx-staging -n staging
kubectl delete namespace dev staging production
```

---

## 🔹 Verify Cleanup

```bash
kubectl get namespaces
kubectl get pods -A
```

---

## 🔥 Quick Revision (1-Min)

```bash
kubectl get namespaces
kubectl create namespace dev
kubectl run nginx --image=nginx -n dev
kubectl apply -f deployment.yaml
kubectl get pods -A
kubectl scale deployment nginx-deployment --replicas=3 -n dev
kubectl set image deployment/nginx-deployment nginx=nginx:1.25 -n dev
kubectl rollout undo deployment/nginx-deployment -n dev
kubectl delete namespace dev
```

```

---
