````markdown
# 🚀 Kubernetes Day 51 – Commands Cheat Sheet

## Apply / Create Resources
```bash
kubectl apply -f nginx-pod.yaml
kubectl apply -f busybox-pod.yaml
````

## Get Pods Information

```bash
kubectl get pods
kubectl get pods -o wide
kubectl get pods --show-labels
```

## Describe Pod

```bash
kubectl describe pod nginx-pod
```

## View Logs

```bash
kubectl logs nginx-pod
kubectl logs busybox-pod
```

## Exec Into Pod

```bash
kubectl exec -it nginx-pod -- /bin/bash
kubectl exec -it busybox-pod -- /bin/sh
```

## Inside Container

```bash
curl localhost:80
exit
```

## Imperative Command

```bash
kubectl run redis-pod --image=redis:latest
```

## Extract YAML

```bash
kubectl get pod redis-pod -o yaml
```

## Generate YAML (Dry Run)

```bash
kubectl run test-pod --image=nginx --dry-run=client -o yaml
```

## Validate YAML

```bash
kubectl apply -f nginx-pod.yaml --dry-run=client
kubectl apply -f nginx-pod.yaml --dry-run=server
```

## Label Operations

```bash
kubectl get pods --show-labels
kubectl get pods -l app=nginx
kubectl get pods -l environment=dev
kubectl label pod nginx-pod environment=production
kubectl label pod nginx-pod environment-
```

## Delete Pods

```bash
kubectl delete pod nginx-pod
kubectl delete pod busybox-pod
kubectl delete pod redis-pod
kubectl delete -f nginx-pod.yaml
kubectl get pods
```

## Delete All Pods

```bash
kubectl delete pods --all
```

## Quick Revision

```bash
kubectl apply -f file.yaml
kubectl get pods -o wide
kubectl describe pod <name>
kubectl logs <name>
kubectl exec -it <name> -- sh
kubectl run pod-name --image=image
kubectl run test --image=nginx --dry-run=client -o yaml
kubectl apply -f file.yaml --dry-run=client
kubectl get pods -l key=value
kubectl label pod <name> key=value
kubectl delete pod <name>
kubectl delete -f file.yaml
```

## Pro Tip

```bash
--dry-run=client -o yaml
```

```
```
