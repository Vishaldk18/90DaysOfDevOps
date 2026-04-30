# Task 1: Learn Terraform Workspaces

```bash
mkdir terraweek-capstone && cd terraweek-capstone
terraform init

# See current workspace
terraform workspace show                    # default

# Create new workspaces
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# List all workspaces
terraform workspace list

# Switch between them
terraform workspace select dev
terraform workspace select staging
terraform workspace select prod
```

## 1️⃣ What does `terraform.workspace` return?

`terraform.workspace` returns the **name of the currently selected Terraform workspace**.

Example:

```hcl
locals {
  env = terraform.workspace
}
```

If you run:

```bash
terraform workspace select prod
```

Then inside the config:

```hcl
terraform.workspace == "prod"
```

✅ Common uses:

*   Naming resources
*   Switching sizes/counts per environment
*   Environment‑specific tagging

```hcl
tags = {
  Environment = terraform.workspace
}
```

***

## 2️⃣ Where does each workspace store its state file?

Terraform stores **one state file per workspace**.

### Local backend (default)

    terraform.tfstate.d/
    ├── dev/
    │   └── terraform.tfstate
    ├── stage/
    │   └── terraform.tfstate
    └── prod/
        └── terraform.tfstate

Each workspace:

*   Uses the **same configuration**
*   But has **isolated state**

### Remote backend (e.g., S3)

State files are separated by workspace name:

    s3://my-bucket/eks/terraform.tfstate          (default)
    s3://my-bucket/eks/env:/dev/terraform.tfstate
    s3://my-bucket/eks/env:/prod/terraform.tfstate

👉 Terraform automatically handles this layout.

***

## 3️⃣ How is this different from separate directories per environment?

### 🟦 Terraform Workspaces

**One directory, one config, multiple states**

✅ Pros:

*   Less code duplication
*   Easy to switch environments
*   Same module versions everywhere

❌ Cons:

*   Easy to accidentally run `apply` in wrong workspace
*   Harder to customize environments deeply
*   Not great for very large teams

**Best for:** small–medium projects, similar environments

***

### 🟩 Separate Directories (recommended for prod systems)

**One directory per environment**

    envs/
    ├── dev/
    ├── stage/
    └── prod/

✅ Pros:

*   Very explicit and safe
*   Different variables, modules, providers
*   Clear Git history and approvals
*   Preferred by Terraform & AWS best practices

❌ Cons:

*   More files
*   Slight duplication (usually solved with modules)

**Best for:** production, regulated, multi‑team environments

***

## 4️⃣ Key differences (quick view)

| Aspect                 | Workspaces   | Separate Directories |
| ---------------------- | ------------ | -------------------- |
| State isolation        | ✅ Yes        | ✅ Yes                |
| Code isolation         | ❌ No         | ✅ Yes                |
| Risk of mistakes       | Higher       | Lower                |
| Customization          | Limited      | Full                 |
| Industry best practice | ⚠️ Sometimes | ✅ Yes                |

***

## ✅ Summary

*   `terraform.workspace` → returns current workspace name
*   Each workspace → has its **own state file**
*   Workspaces ≠ environments (they only isolate state)
*   **Use workspaces** for simple or demo setups
*   **Use separate directories** for real production systems

> 💡 Rule of thumb:  
> **If prod matters → don’t use workspaces for isolation**

***

### Task 2: Set Up the Project Structure
Create this layout:

```
terraweek-capstone/
  main.tf                   # Root module -- calls child modules
  variables.tf              # Root variables
  outputs.tf                # Root outputs
  providers.tf              # AWS provider and backend
  locals.tf                 # Local values using workspace
  dev.tfvars                # Dev environment values
  staging.tfvars            # Staging environment values
  prod.tfvars               # Prod environment values
  .gitignore                # Ignore state, .terraform, tfvars with secrets
  modules/
    vpc/
      main.tf
      variables.tf
      outputs.tf
    security-group/
      main.tf
      variables.tf
      outputs.tf
    ec2-instance/
      main.tf
      variables.tf
      outputs.tf
```

Create the `.gitignore`:
```
.terraform/
*.tfstate
*.tfstate.backup
*.tfvars
.terraform.lock.hcl
```
---

### 📘 Why this Terraform file structure is considered **best practice**

This structure follows **Terraform and industry‑proven conventions** for building **scalable, safe, and maintainable infrastructure**.

***

## ✅ 1. Clear separation of responsibilities

*   **Root module (`main.tf`)** orchestrates resources
*   **Child modules (`modules/`)** encapsulate reusable logic (VPC, SG, EC2)
*   Each file has a *single purpose* (providers, variables, outputs)

➡️ Makes the code easier to understand and debug.

***

## ✅ 2. Reusability and DRY principle

*   Modules can be reused across:
    *   dev / staging / prod
    *   different projects
*   Avoids copy‑pasting infrastructure code

➡️ Changes in one module improve all environments.

***

## ✅ 3. Environment isolation without duplication

*   `dev.tfvars`, `staging.tfvars`, `prod.tfvars`  
    → same code, different values
*   Works cleanly with **Terraform workspaces**

➡️ Consistent infra with environment‑specific configuration.

***

## ✅ 4. Safer production workflow

*   Explicit environments reduce accidental changes
*   Supports approvals, CI/CD pipelines, and access controls

➡️ Aligns with real‑world production standards.

***

## ✅ 5. Scales with team size

*   Teams can own modules independently
*   Easier code reviews and collaboration
*   Predictable file locations

➡️ Essential for medium to large teams.

***

## ✅ 6. Secure by default (`.gitignore`)

Prevents committing:

*   State files
*   Provider lock/cache
*   Sensitive `.tfvars`

➡️ Protects secrets and avoids state corruption.

***

## ✅ 7. Industry‑standard and future‑proof

*   Matches Terraform documentation examples
*   Easily extendable (add RDS, EKS, ALB modules)
*   Compatible with CI/CD and remote backends

***

### ✅ Summary

This structure is best practice because it is:

*   ✅ Modular
*   ✅ Reusable
*   ✅ Secure
*   ✅ Environment‑aware
*   ✅ Scalable
*   ✅ Production‑ready

> **Rule of thumb:**  
> *If infrastructure will grow or touch production → use this structure.*

## ✅ Task 3: Custom Terraform Modules

***

## 🔹 Module 1: VPC

### `modules/vpc/variables.tf`

```hcl
variable "cidr" {}
variable "public_subnet_cidr" {}
variable "environment" {}
variable "project_name" {}
```

### `modules/vpc/main.tf`

```hcl
resource "aws_vpc" "this" {
  cidr_block = var.cidr

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-subnet"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-igw"
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
```

### `modules/vpc/outputs.tf`

```hcl
output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_id" {
  value = aws_subnet.public.id
}
```

***

## 🔹 Module 2: Security Group

### `modules/security-group/variables.tf`

```hcl
variable "vpc_id" {}
variable "ingress_ports" {
  type = list(number)
}
variable "environment" {}
variable "project_name" {}
```

### `modules/security-group/main.tf`

```hcl
resource "aws_security_group" "this" {
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-sg"
    Environment = var.environment
  }
}
```

### `modules/security-group/outputs.tf`

```hcl
output "sg_id" {
  value = aws_security_group.this.id
}
```

***

## 🔹 Module 3: EC2 Instance

### `modules/ec2-instance/variables.tf`

```hcl
variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "security_group_ids" {
  type = list(string)
}
variable "environment" {}
variable "project_name" {}
```

### `modules/ec2-instance/main.tf`

```hcl
resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-instance"
    Environment = var.environment
    Project     = var.project_name
  }
}
```

### `modules/ec2-instance/outputs.tf`

```hcl
output "instance_id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = aws_instance.this.public_ip
}
```


### Task 4: Wire It All Together with Workspace-Aware Config
In the root module, use `terraform.workspace` to drive environment-specific behavior.

**`locals.tf`:**
```hcl
locals {
  environment = terraform.workspace
  name_prefix = "${var.project_name}-${local.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = local.environment
    ManagedBy   = "Terraform"
    Workspace   = terraform.workspace
  }
}
```

**`variables.tf`:**
```hcl
variable "project_name" {
  type    = string
  default = "terraweek"
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ingress_ports" {
  type    = list(number)
  default = [22, 80]
}
```

**`main.tf`** -- call all three modules, passing workspace-aware names and variables.

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

module "vpc" {
  source = "./modules/vpc"

  cidr               = var.vpc_cidr
  public_subnet_cidr = var.subnet_cidr
  environment        = local.environment
  project_name       = var.project_name
}

module "security_group" {
  source = "./modules/security-group"

  vpc_id        = module.vpc.vpc_id
  ingress_ports = var.ingress_ports
  environment   = local.environment
  project_name  = var.project_name
}

module "ec2" {
  source = "./modules/ec2-instance"

  ami_id               = data.aws_ami.amazon_linux.id
  instance_type        = var.instance_type
  subnet_id            = module.vpc.subnet_id
  security_group_ids   = [module.security_group.sg_id]
  environment          = local.environment
  project_name         = var.project_name
}

```

**`providers.tf`**
```
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"

  default_tags {
    tags = local.common_tags
  }
}

```

**Environment-specific tfvars:**

`dev.tfvars`:
```hcl
vpc_cidr      = "10.0.0.0/16"
subnet_cidr   = "10.0.1.0/24"
instance_type = "t2.micro"
ingress_ports = [22, 80]
```

`staging.tfvars`:
```hcl
vpc_cidr      = "10.1.0.0/16"
subnet_cidr   = "10.1.1.0/24"
instance_type = "t2.small"
ingress_ports = [22, 80, 443]
```

`prod.tfvars`:
```hcl
vpc_cidr      = "10.2.0.0/16"
subnet_cidr   = "10.2.1.0/24"
instance_type = "t3.small"
ingress_ports = [80, 443]
```

Notice: dev allows SSH, prod does not. Different CIDRs prevent overlap. Instance types scale up per environment.

---

### Task 5: Deploy All Three Environments
Deploy each environment using its workspace and tfvars file:

**Dev:**
```bash
terraform workspace select dev
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

**Staging:**
```bash
terraform workspace select staging
terraform plan -var-file="staging.tfvars"
terraform apply -var-file="staging.tfvars"
```

**Prod:**
```bash
terraform workspace select prod
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

After all three are deployed, verify:
```bash
# Check each workspace's resources
terraform workspace select dev && terraform output
terraform workspace select staging && terraform output
terraform workspace select prod && terraform output
```

Go to the AWS console and verify:
- Three separate VPCs with different CIDR ranges
- Three EC2 instances with different instance types
- Different Name tags per environment: `terraweek-dev-server`, `terraweek-staging-server`, `terraweek-prod-server`

**Verify:** Are all three environments completely isolated from each other?

---

### Task 6: Document Best Practices
Write down everything you have learned this week as a Terraform best practices guide:

1. **File structure** -- separate files for providers, variables, outputs, main, locals
2. **State management** -- always use remote backend, enable locking, enable versioning
3. **Variables** -- never hardcode, use tfvars per environment, validate with `validation` blocks
4. **Modules** -- one concern per module, always define inputs/outputs, pin registry module versions
5. **Workspaces** -- use for environment isolation, reference `terraform.workspace` in configs
6. **Security** -- .gitignore for state and tfvars, encrypt state at rest, restrict backend access
7. **Commands** -- always run `plan` before `apply`, use `fmt` and `validate` before committing
8. **Tagging** -- tag every resource with project, environment, and managed-by
9. **Naming** -- consistent prefix pattern: `<project>-<environment>-<resource>`
10. **Cleanup** -- always `terraform destroy` non-production environments when not in use

---

### Task 7: Destroy All Environments
Clean up all three environments in reverse order:

```bash
terraform workspace select prod
terraform destroy -var-file="prod.tfvars"

terraform workspace select staging
terraform destroy -var-file="staging.tfvars"

terraform workspace select dev
terraform destroy -var-file="dev.tfvars"
```

Verify in the AWS console -- all VPCs, instances, security groups, and gateways should be gone.

Delete the workspaces:
```bash
terraform workspace select default
terraform workspace delete dev
terraform workspace delete staging
terraform workspace delete prod
```

**Verify:** Is your AWS account completely clean?

---

## Hints
- Each workspace has its own state file -- `terraform.tfstate.d/<workspace>/terraform.tfstate`
- `terraform.workspace` is a built-in variable available in any config
- You cannot delete a workspace you are currently on -- switch to `default` first
- Different VPC CIDRs per environment prevent accidental peering conflicts
- `terraform plan -var-file` does NOT auto-load `terraform.tfvars` when you specify `-var-file`
- If you forget which workspace you are on: `terraform workspace show`
- Workspaces work with remote backends too -- S3 key becomes `env:/<workspace>/terraform.tfstate`

---

## Documentation
Create `day-67-terraweek-capstone.md` with:
- Your complete project structure (directory tree)
- All three custom module configs
- Root `main.tf` showing workspace-aware module calls
- All three tfvars files with the differences highlighted
- Screenshot of all three environments running simultaneously in AWS
- Screenshot of `terraform output` from each workspace
- Your Terraform best practices guide (Task 6)
- A table mapping each TerraWeek day to the concepts learned:

| Day | Concepts |
|-----|----------|
| 61 | IaC, HCL, init/plan/apply/destroy, state basics |
| 62 | Providers, resources, dependencies, lifecycle |
| 63 | Variables, outputs, data sources, locals, functions |
| 64 | Remote backend, locking, import, drift |
| 65 | Custom modules, registry modules, versioning |
| 66 | EKS with modules, real-world provisioning |
| 67 | Workspaces, multi-env, capstone project |

---


