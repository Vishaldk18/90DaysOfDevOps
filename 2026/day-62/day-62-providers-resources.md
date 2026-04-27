Task 1: Explore the AWS Provider

terraform{
 required_providers{
    aws = {
       source = "hashicorp/aws"
       version = "~> 5.0"
    }
 }
}


provider "aws" {
  region = "eu-north-1"
}


**In short:**

### `.terraform.lock.hcl`

*   Locks the **exact provider versions and checksums**
*   Ensures **consistent, reproducible Terraform runs**
*   Should be **committed to Git**

***

### Version constraints

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

### Quick takeaway

👉 Use **`~> major.minor`** and commit `.terraform.lock.hcl` for safe, stable setups.


Task 2: Build a VPC from Scratch
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


Task 3: Understand Implicit Dependencies
How does Terraform know to create the VPC before the subnet?
Terraform builds a dependency graph by analyzing resource references.
When a subnet uses vpc_id = aws_vpc.main.id, Terraform knows the subnet depends on the VPC, so it creates the VPC first automatically.

What would happen if the subnet was created before the VPC existed?
Terraform would not allow this because the dependency graph prevents it.
If it did try, AWS would return an error like “VPC does not exist”.
✅ Key Point: Terraform uses implicit dependencies from references, so manual ordering is usually unnecessary.


Find all implicit dependencies in your config and list them
Terraform determines creation order using its dependency graph, which is built from resource attribute references.
In this configuration, the implicit dependencies are:

Subnet → VPC (vpc_id = aws_vpc.main.id)
Internet Gateway → VPC (vpc_id = aws_vpc.main.id)
Route Table → VPC (vpc_id = aws_vpc.main.id)
Route Table → Internet Gateway (gateway_id = aws_internet_gateway.gw.id)
Route Table Association → Route Table (route_table_id = aws_route_table.public-rt.id)
Route Table Association → Subnet (subnet_id = aws_subnet.public-subnet.id)

Because of these references, Terraform automatically creates resources in the correct order:
VPC first, then subnet, internet gateway, route table, and finally the route table association.


