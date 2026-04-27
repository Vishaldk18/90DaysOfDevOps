## ✅ Task 1: Explore the AWS Provider

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}
```

### `.terraform.lock.hcl`

*   Locks the **exact provider versions and checksums**
*   Ensures **consistent, reproducible Terraform runs**
*   Should be **committed to Git**

***

### Version Constraints

*   **`~> 5.0`**  
    ✅ Allows **any 5.x version**  
    ❌ Blocks 6.0+  
    → *Most recommended*

*   **`>= 5.0`**  
    ✅ Allows 5.x, 6.x, 7.x…  
    ❌ Risk of breaking changes

*   **`= 5.0.0`**  
    ✅ Only 5.0.0  
    ❌ No bug/security fixes

***

### Quick Takeaway

👉 Use **`~> major.minor`** and commit `.terraform.lock.hcl` for safe, stable setups.

***

## ✅ Task 2: Build a VPC from Scratch

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "TerraWeek-VPC"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "TerraWeek-Public-Subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "rta" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.public-subnet.id
}
```

***

## ✅ Task 3: Understand Implicit Dependencies

### How does Terraform know to create the VPC before the subnet?

Terraform builds a dependency graph by analyzing resource references.  
When a subnet uses `vpc_id = aws_vpc.main.id`, Terraform knows the subnet depends on the VPC, so it creates the VPC first automatically.

### What would happen if the subnet was created before the VPC existed?

Terraform would not allow this because the dependency graph prevents it.  
If it did try, AWS would return an error like:

> “VPC does not exist”

✅ **Key Point:** Terraform uses implicit dependencies from references, so manual ordering is usually unnecessary.

***

### Find all implicit dependencies in your config

*   Subnet → VPC (`vpc_id = aws_vpc.main.id`)
*   Internet Gateway → VPC (`vpc_id = aws_vpc.main.id`)
*   Route Table → VPC (`vpc_id = aws_vpc.main.id`)
*   Route Table → Internet Gateway (`gateway_id = aws_internet_gateway.gw.id`)
*   Route Table Association → Route Table (`route_table_id = aws_route_table.public-rt.id`)
*   Route Table Association → Subnet (`subnet_id = aws_subnet.public-subnet.id`)

Terraform automatically creates resources in the correct order:
**VPC → Subnet / IGW → Route Table → Route Table Association**

***

## ✅ Task 4: Add a Security Group and EC2 Instance

## ✅ Task 5: Explicit Dependencies with `depends_on`

```hcl
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "TerraWeek-SG"
  } 
}

resource "aws_vpc_security_group_ingress_rule" "allow-ssh" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow-http" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow-outbound-traffic" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "my-instance" {
  ami                         = "ami-0a0823e4ea064404d"
  subnet_id                   = aws_subnet.public-subnet.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]

  tags = {
    Name = "TerraWeek-Server"
  }
}

resource "aws_s3_bucket" "second-bucket" {
  bucket     = "my-second-ucket-demo"
  depends_on = [aws_instance.my-instance]
}
```

***

### When would you use `depends_on` in real projects?

Use `depends_on` only when Terraform **can’t infer dependencies automatically**, typically with:

*   **IAM permissions**
*   **Asynchronous resources** like NAT gateways

#### Key Rules

*   ❌ Don’t use `depends_on` when references exist
*   ✅ Use it only for hidden, logical, or timing‑based dependencies

***

## ✅ Task 6: Lifecycle Rules and Destroy

```hcl
resource "aws_instance" "my-instance" {
  ami                         = "ami-0a0823e4ea064404d"
  subnet_id                   = aws_subnet.public-subnet.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "TerraWeek-Server"
  }
}
```

***

### What are the three lifecycle arguments and when would you use each?

*   **`create_before_destroy`**  
    Avoids downtime by creating the new resource before deleting the old one.

*   **`prevent_destroy`**  
    Protects critical resources from accidental deletion.

*   **`ignore_changes`**  
    Avoids conflicts when resources are modified outside Terraform.

✅ **Summary:**  
`create_before_destroy` avoids downtime, `prevent_destroy` protects critical resources, and `ignore_changes` prevents unnecessary diffs caused by external changes.
