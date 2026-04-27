Task 1: Extract Variables

variable "region"{
 type = string
 default = "eu-north-1"
}

variable "vpc_cidr"{
 type = string
 default = "10.0.0.0/16"
}

variable "subnet_cidr"{
 type = string
 default = "10.0.1.0/24"
}

variable "instance_type"{
 type = string
 default = "t3.micro"
}

variable "project_name"{
 type = string
}

variable "environment"{
 type = string
 default = "dev"
}

variable "allowed_ports"{
 type = list(number)
 default = [22, 80, 443]
}

variable "extra_tags"{
 type = map(string)
 default = {}
}

What are the five variable types in Terraform?
string – Stores text values (e.g., region names, project names)
number – Stores numeric values (e.g., instance count, port numbers)
bool – Stores true or false values (e.g., enable or disable a feature)
list – Ordered collection of values (e.g., list of ports or AZs)
map – Key–value pairs (e.g., resource tags)




Task 2: Variable Files and Precedence

Create terraform.tfvars:
project_name = "terraweek"
environment  = "dev"
instance_type = "t2.micro"
Create prod.tfvars:
project_name = "terraweek"
environment  = "prod"
instance_type = "t3.small"
vpc_cidr     = "10.1.0.0/16"
subnet_cidr  = "10.1.1.0/24"
Apply with the default file:
terraform plan                              # Uses terraform.tfvars automatically
Apply with the prod file:
terraform plan -var-file="prod.tfvars"      # Uses prod.tfvars
Override with CLI:
terraform plan -var="instance_type=t2.nano"  # CLI overrides everything
Set an environment variable:
export TF_VAR_environment="staging"
terraform plan 

Terraform variable precedence (lowest → highest priority):

Variable defaults – Values defined using default in variable blocks
.tfvars files – terraform.tfvars and *.auto.tfvars files
Environment variables – Variables set as TF_VAR_<name>
Command-line options – -var and -var-file (highest priority)

✅ Command-line values override everything else.


Task 3: Add Outputs
output "vpc_id"{
 value = aws_vpc.main.id
}

output "subnet_id"{
 value = aws_subnet.public-subnet.id
}

output "instance_id"{
 value = aws_instance.my-instance.id
}

output "instance_public_ip"{
 value = aws_instance.my-instance.public_ip
}

output "instance_public_dns"{
 value = aws_instance.my-instance.public_dns
}

output "security_group_id"{
 value = aws_security_group.sg.id
}


terraform output                          # Show all outputs
terraform output instance_public_ip       # Show a specific output
terraform output -json                    # JSON format for scripting

Task 6: Built-in Functions and Conditional Expressions
> upper("terraweek")
"TERRAWEEK"
> join("-", ["terra", "week", "2026"])
"terra-week-2026"
> format("arn:aws:s3:::%s", "my-bucket")
"arn:aws:s3:::my-bucket"
> length(["a", "b", "c"])
3
> lookup({dev = "t2.micro", prod = "t3.small"}, "dev")
"t2.micro"
> toset(["a", "b", "a"])
toset([
  "a",
  "b",
])
> cidrsubnet("10.0.0.0/16", 8, 1)
"10.0.1.0/24"

```hcl
cidrsubnet("10.0.0.0/16", 8, 1)
```

👉 Divides the `/16` network into `/24` subnets and returns the **2nd subnet**, which is:

    10.0.1.0/24

**Meaning:**  
“From `10.0.0.0/16`, create smaller subnets and pick subnet number 1.” ✅


Conditional expression -- add this to your config:

instance_type = var.environment == "prod" ? "t3.small" : "t2.micro"
