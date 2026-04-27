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
