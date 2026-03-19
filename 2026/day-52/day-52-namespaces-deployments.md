What namespaces are and why you would use them
Namespaces are virtual clusters inside a Kubernetes cluster used to logically isolate resources like Pods, Deployments, and Services. 
They help in organizing workloads, separating environments (dev/staging/prod), and applying access control and resource limits.


apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx   
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        ports:
        - containerPort: 80

apiVersion → Defines which API version to use (apps/v1)

kind → Type of resource (Deployment)

metadata → Name, namespace, labels

spec → Desired state of Deployment

Inside spec:

replicas → Number of Pods to run

selector → Matches Pods managed by Deployment

template → Blueprint for creating Pods

Inside template.spec:

containers → Container configuration (image, ports, etc.)


What happens when you delete a Pod managed by a Deployment vs a standalone Pod
A standalone Pod is permanently deleted since no controller manages it. However, if a Pod is managed by a Deployment, 
Kubernetes automatically recreates it to maintain the desired number of replicas.


How scaling works (both imperative and declarative)
Declarative scaling is done by updating the replicas field in the YAML file and applying it, 
while imperative scaling is done using kubectl scale to directly change the number of replicas.


How rolling updates and rollbacks work
Rolling updates update Pods gradually by replacing old versions with new ones without downtime. 
Kubernetes ensures some Pods are always available. Rollbacks allow reverting to a previous stable version using rollout history.
