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
