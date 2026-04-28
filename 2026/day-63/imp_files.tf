varibales.tf

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


terraform.tfvars

project_name = "terraweek"
environment  = "dev"
instance_type = "t3.micro"

outputs.tf

output "vpc_id"{
 value = aws_vpc.main.id
}

output "subnet_id"{
 value = aws_subnet.public_subnet.id
}

output "instance_id"{
 value = aws_instance.my_instance.id
}

output "instance_public_ip"{
 value = aws_instance.my_instance.public_ip
}

output "instance_public_dns"{
 value = aws_instance.my_instance.public_dns
}

output "security_group_id"{
 value = aws_security_group.sg.id
}


providers.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = var.region
}
