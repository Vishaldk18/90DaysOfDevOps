## ✅ Task 1: Project Setup

### 📁 Directory Structure

```text
terraform-eks/
├── providers.tf        # Provider and backend config
├── vpc.tf              # VPC module call
├── eks.tf              # EKS module call
├── variables.tf        # All input variables
├── outputs.tf          # Cluster outputs
├── terraform.tfvars    # Variable values
└── k8s/
    └── nginx-deployment.yaml
```

***

### 📄 `providers.tf`

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
  }

  # Optional: Remote backend
  # backend "s3" {
  #   bucket         = "my-terraform-state-bucket"
  #   key            = "eks/terraform.tfstate"
  #   region         = "ap-south-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.region
}

# Kubernetes provider (configured after cluster creation)
provider "kubernetes" {
  host                   = null
  cluster_ca_certificate = null
  token                  = null
}
```

***

### 📄 `variables.tf`

```hcl
variable "region" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = "terraweek-eks"
}

variable "cluster_version" {
  type    = string
  default = "1.31"
}

variable "node_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "node_desired_count" {
  type    = string
  default = 2
}
```

***

## ✅ Task 2: Create the VPC (Registry Module)

### 📄 `vpc.tf`

```hcl
data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "terraweek-vpc"
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb"              = "1"
    "kubernetes.io/cluster/terraweek-eks" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"     = "1"
    "kubernetes.io/cluster/terraweek-eks" = "shared"
  }
}
```

***

### ❓ Why does EKS need both public and private subnets?

#### 🔒 Private subnets → Worker Nodes

*   No public IPs (secure by default)
*   Outbound internet access via NAT Gateway
*   Used for ECR, AWS APIs, OS updates

#### 🌍 Public subnets → Load balancers & NAT

*   Host ALB / NLB for internet access
*   Contain NAT Gateway for private subnets

***

### 🏷️ Subnet Tags Explained

*   `kubernetes.io/role/elb`  
    → Internet‑facing LoadBalancers

*   `kubernetes.io/role/internal-elb`  
    → Internal LoadBalancers

*   `kubernetes.io/cluster/<cluster-name>`  
    → Allows EKS to discover & use the subnet

> ⚠️ Without these tags, LoadBalancer services will not work.

***

## ✅ Task 3: Create the EKS Cluster (Registry Module)

### 📄 `eks.tf`

```hcl
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  # REQUIRED for kubectl access
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    terraweek_nodes = {
      ami_type       = "AL2_x86_64"
      instance_types = [var.node_instance_type]

      min_size     = 1
      max_size     = 3
      desired_size = var.node_desired_count
    }
  }

  tags = {
    Environment = "dev"
    Project     = "TerraWeek"
    ManagedBy   = "Terraform"
  }
}
```

***

### ▶️ Initialize & Plan

```bash
terraform init
terraform plan
```

***

## ✅ Task 4: Apply and Connect kubectl

### ▶️ Apply Terraform

```bash
terraform apply
```

***

### 📄 `outputs.tf`

```hcl
output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_region" {
  value = var.region
}
```

***

### 🔑 Configure kubeconfig

```bash
aws eks update-kubeconfig \
  --name terraweek-eks \
  --region <your-region>
```

***

### ✅ Verify Cluster

```bash
kubectl get nodes
kubectl get pods -A
kubectl cluster-info
```

***

## ✅ Task 5: Deploy a Workload

### 📄 `k8s/nginx-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-terraweek
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
        image: nginx:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: LoadBalancer
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
```

***

### ▶️ Apply Workload

```bash
kubectl apply -f k8s/nginx-deployment.yaml
```

***

### 🌐 Wait for External IP

```bash
kubectl get svc nginx-service -w
```

Access the **LoadBalancer URL** in your browser.

***

### ✅ Verify Everything

```bash
kubectl get nodes
kubectl get deployments
kubectl get pods
kubectl get svc
```

***

## ✅ Task 6: Destroy Everything

### 🔥 Remove Kubernetes Resources

```bash
kubectl delete -f k8s/nginx-deployment.yaml
```

Wait until:

*   AWS Load Balancer is fully deleted

***

### 🧨 Destroy Terraform Resources

```bash
terraform destroy
```

⏳ Takes \~10–15 minutes.

***
