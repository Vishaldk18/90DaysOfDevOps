## 📌 Task 1: Extract Variables

### Terraform Variables

```hcl
variable "region"{
  type    = string
  default = "eu-north-1"
}

variable "vpc_cidr"{
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr"{
  type    = string
  default = "10.0.1.0/24"
}

variable "instance_type"{
  type    = string
  default = "t3.micro"
}

variable "project_name"{
  type = string
}

variable "environment"{
  type    = string
  default = "dev"
}

variable "allowed_ports"{
  type    = list(number)
  default = [22, 80, 443]
}

variable "extra_tags"{
  type    = map(string)
  default = {}
}
````

### ✅ Five Variable Types in Terraform

*   **string** – Stores text values  
    *Example*: region names, project names

*   **number** – Stores numeric values  
    *Example*: instance count, port numbers

*   **bool** – Stores true/false values  
    *Example*: enable or disable a feature

*   **list** – Ordered collection of values  
    *Example*: list of ports or availability zones

*   **map** – Key–value pairs  
    *Example*: resource tags

***

## 📌 Task 2: Variable Files and Precedence

### `terraform.tfvars`

```hcl
project_name  = "terraweek"
environment   = "dev"
instance_type = "t2.micro"
```

### `prod.tfvars`

```hcl
project_name  = "terraweek"
environment   = "prod"
instance_type = "t3.small"
vpc_cidr      = "10.1.0.0/16"
subnet_cidr   = "10.1.1.0/24"
```

### Apply Scenarios

**Default file**

```bash
terraform plan
```

**With prod file**

```bash
terraform plan -var-file="prod.tfvars"
```

**Command-line override**

```bash
terraform plan -var="instance_type=t2.nano"
```

**Using environment variable**

```bash
export TF_VAR_environment="staging"
terraform plan
```

### 🔐 Variable Precedence (Lowest → Highest)

1.  Variable defaults
2.  `.tfvars` files (`terraform.tfvars`, `*.auto.tfvars`)
3.  Environment variables (`TF_VAR_<name>`)
4.  Command-line options (`-var`, `-var-file`)

✅ **Command-line values override everything else**

***

## 📌 Task 3: Add Outputs

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.public-subnet.id
}

output "instance_id" {
  value = aws_instance.my-instance.id
}

output "instance_public_ip" {
  value = aws_instance.my-instance.public_ip
}

output "instance_public_dns" {
  value = aws_instance.my-instance.public_dns
}

output "security_group_id" {
  value = aws_security_group.sg.id
}
```

### View Outputs

```bash
terraform output
terraform output instance_public_ip
terraform output -json
```

***

## 📌 Task 4: Use Data Sources

### Data Sources

```hcl
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
```

### Infrastructure Resources (Excerpt)

```hcl
resource "aws_vpc" "main" {
  cidr_block             = var.vpc_cidr
  enable_dns_support     = true
  enable_dns_hostnames   = true
}
```

### Resource vs Data Source

*   **Resource** → Creates/manages infrastructure
*   **Data Source** → Reads existing infrastructure only

✅ Terraform manages lifecycle **only for resources**

***

## 📌 Task 5: Use Locals for Dynamic Values

### Locals Block

```hcl
locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```

### Example Usage

```hcl
tags = merge(local.common_tags, {
  Name = "${local.name_prefix}-server"
})
```

✅ Ensures **consistent naming and tagging** across all resources.

***

## 📌 Task 6: Built-in Functions & Conditional Expressions

### Built-in Function Examples

```hcl
upper("terraweek")                         # "TERRAWEEK"
join("-", ["terra", "week", "2026"])       # "terra-week-2026"
format("arn:aws:s3:::%s", "my-bucket")     # "arn:aws:s3:::my-bucket"
length(["a", "b", "c"])                    # 3
lookup({dev="t2.micro", prod="t3.small"}, "dev")
toset(["a", "b", "a"])
cidrsubnet("10.0.0.0/16", 8, 1)             # "10.0.1.0/24"
```

### CIDR Subnet Explanation

```hcl
cidrsubnet("10.0.0.0/16", 8, 1)
```

👉 Divides `/16` into `/24` subnets and returns the **2nd subnet**  
✅ Result: `10.0.1.0/24`

***

### Conditional Expression Example

```hcl
instance_type = var.environment == "prod" ? "t3.small" : "t2.micro"
```

✅ Automatically selects instance type based on environment.
