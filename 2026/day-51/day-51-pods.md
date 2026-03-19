Your nginx, busybox, and third pod manifests
apiVersion: v1
kind: Pod
metadata:
 name: busybox-pod
 labels:
   app: busybox
spec:
  containers:
  - name: busybox-ctr
    image: busybox:latest
    command: ["sh","-c","echo hello from busybox && sleep 3600"]


apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx-ctr
    image: nginx:latest
    ports:
    - containerPort: 80

The four required fields of a Kubernetes manifest and what each does
Difference between imperative (kubectl run) and declarative (kubectl apply -f)
What happens when you delete a standalone Pod?

1. Kubernetes Manifest Fields:
- apiVersion: Defines API version
- kind: Type of resource
- metadata: Identification (name, labels)
- spec: Desired state/configuration

2. Imperative vs Declarative:
- Imperative: Direct commands (kubectl run), quick but not reusable
- Declarative: YAML-based (kubectl apply), version-controlled and preferred

3. Deleting Standalone Pod:
- Pod is permanently deleted
- Not recreated automatically
- Recommended to use Deployment for self-healing
