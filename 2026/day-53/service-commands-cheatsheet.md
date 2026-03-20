# Kubernetes Services – Command Cheat Sheet

---

## 🚀 Deployment Commands

### Apply Deployment
kubectl apply -f app-deployment.yaml

### Check Pods (with IPs)
kubectl get pods -o wide

---

## 🌐 ClusterIP Service Commands

### Apply ClusterIP Service
kubectl apply -f clusterip-service.yaml

### List Services
kubectl get services

---

## 🧪 Test Service from Inside Cluster

### Create Temporary Debug Pod
kubectl run test-client --image=busybox:latest --rm -it --restart=Never -- sh

### Inside Pod – Test Service
wget -qO- http://web-app-clusterip

### Exit Pod
exit

---

## 🔎 DNS Testing Commands

### Create DNS Test Pod
kubectl run dns-test --image=busybox:latest --rm -it --restart=Never -- sh

### Test using short DNS name
wget -qO- http://web-app-clusterip

### Test using full DNS name
wget -qO- http://web-app-clusterip.default.svc.cluster.local

### DNS Lookup
nslookup web-app-clusterip

### Exit Pod
exit

---

## 🌍 NodePort Service Commands

### Apply NodePort Service
kubectl apply -f nodeport-service.yaml

### List Services
kubectl get services

---

### Access NodePort Service

#### Minikube
minikube service web-app-nodeport --url

#### Kind / General
kubectl get nodes -o wide
curl http://<NodeIP>:30080

#### Docker Desktop
curl http://localhost:30080

---

## ☁️ LoadBalancer Service Commands

### Apply LoadBalancer Service
kubectl apply -f loadbalancer-service.yaml

### Check Services
kubectl get services

---

### Minikube LoadBalancer Support
minikube tunnel

---

## 🔍 Inspection & Debugging Commands

### Get Services with Details
kubectl get services -o wide

### Describe Service (very important)
kubectl describe service web-app-loadbalancer

### Check Endpoints (Pod IPs behind Service)
kubectl get endpoints web-app-clusterip

### Detailed Endpoints Info
kubectl describe endpoints web-app-clusterip

---

## 🧹 Cleanup Commands

### Delete Deployment
kubectl delete -f app-deployment.yaml

### Delete Services
kubectl delete -f clusterip-service.yaml
kubectl delete -f nodeport-service.yaml
kubectl delete -f loadbalancer-service.yaml

---

### Verify Cleanup
kubectl get pods
kubectl get services

---

## ⚡ Useful Notes

- `--rm` → deletes pod automatically after exit
- `-it` → interactive terminal
- `--restart=Never` → creates a Pod (not Deployment)
- `wget -qO-` → silent HTTP request, prints response to terminal
- NodePort range → `30000–32767`
- Use `kubectl describe service <name>` for deep debugging
- Use `kubectl get endpoints` to verify pod connectivity

---
