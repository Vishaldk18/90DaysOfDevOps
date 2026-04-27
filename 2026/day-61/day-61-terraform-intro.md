## Task 1: Understand Infrastructure as Code

**IaC** means managing infrastructure (servers, networks, databases) **using code instead of manual setup**.

### Why it matters in DevOps
- Automates infrastructure
- Ensures consistency across environments
- Enables version control, reviews, and CI/CD
- Reduces human errors

### Problems IaC Solves vs AWS Console
- Manual errors → automated, repeatable setups  
- No history → version‑controlled changes  
- Hard to recreate → easy environment replication  
- Slow provisioning → fast, scripted deployment  

---

## Terraform vs Other Tools

### Terraform vs CloudFormation
- Terraform: multi‑cloud  
- CloudFormation: AWS‑only  

### Terraform vs Ansible
- Terraform: creates infrastructure  
- Ansible: configures servers/software  

### Terraform vs Pulumi
- Terraform: simple declarative language (HCL)  
- Pulumi: real programming languages  

---

## Key Terraform Concepts
- **Declarative**: Define *what you want*, Terraform decides *how to do it*
- **Cloud‑agnostic**: Same tool for AWS, Azure, GCP, etc.

---

## Task 2: Install Terraform and Configure AWS

---

## Task 3: Your First Terraform Config – Create an S3 Bucket

```hcl
provider "aws" {
  region = "eu-north-1"
}

resource "aws_s3_bucket" "my-bucket" {
  bucket = "vishaldk18-new-bucket"
}
````

### Terraform Initialization

*   **`terraform init` downloads**: required **providers**, **modules**, and **backend plugins**
*   **`.terraform/` directory**: local cache holding **provider binaries**, **module code**, and **backend metadata**
*   ✅ Safe to delete; Terraform recreates it on next `terraform init`

***

## Task 4: Add an EC2 Instance

```hcl
resource "aws_instance" "my-instance" {
  ami           = "ami-0a0823e4ea064404d"
  instance_type = "t3.micro"

  tags = {
    Name = "TerraWeek-Day1"
  }
}
```

### How Does Terraform Know Only EC2 Needs to Be Created?

Terraform knows because of **state + refresh from the provider API**.

#### How it works:

1.  **Terraform state file (`terraform.tfstate`)**
    *   Records resources Terraform already manages (like the S3 bucket)
    *   If the bucket is in state, Terraform knows it exists

2.  **State refresh (during `plan` / `apply`)**
    *   Terraform asks AWS: *“Does this resource exist and match the config?”*
    *   If the S3 bucket exists and matches → **no change**
    *   If the EC2 instance is missing → **mark for creation**

3.  **Execution plan**
    *   Terraform compares:
        *   Desired config
        *   Current state
        *   Actual AWS infrastructure
    *   Result: Only EC2 is created

**In one line:**

*   ✅ S3 exists in state and AWS → no action
*   ✅ EC2 missing → Terraform creates it

> If the S3 bucket existed **but was not in state**, Terraform would try to create it unless you run `terraform import`.

***

## Task 5: Understand the State File

### Terraform State Commands

```bash
terraform show
```

✅ Shows a **human‑readable view of the current Terraform state**.

```bash
terraform state list
```

✅ Lists **all resources Terraform is managing**.

```bash
terraform state show aws_s3_bucket.<name>
```

✅ Shows **detailed state** of a specific S3 bucket.

```bash
terraform state show aws_instance.<name>
```

✅ Shows **detailed state** of a specific EC2 instance.

### Summary

*   `show` → entire state summary
*   `state list` → resource names only
*   `state show` → detailed resource data

These commands are **read‑only** and do **not** modify infrastructure.

***

### What Information Does the State File Store?

For each resource:

*   Resource ID (real cloud ID)
*   Resource type & name (e.g., `aws_s3_bucket.logs`)
*   Current attributes (ARNs, IPs, tags, etc.)
*   Dependencies
*   Provider metadata

✅ Used to map **code ↔ real infrastructure**

***

### Why You Should NEVER Edit the State File Manually

*   High risk of corruption
*   May destroy or recreate resources accidentally
*   Breaks dependency tracking
*   No validation

✅ Use Terraform commands instead:

```bash
terraform state mv
terraform state rm
terraform import
```

***

### Why the State File Should NOT Be Committed to Git

*   Contains sensitive data (passwords, secrets, private IPs)
*   Causes merge conflicts
*   Security risk if leaked

✅ Best practices:

*   Use a **remote backend** (S3 + DynamoDB, Terraform Cloud)
*   Add `terraform.tfstate*` to `.gitignore`

> **One‑line summary:**  
> The state file is Terraform’s **source of truth**—never edit it, never commit it, and always protect it.

***

## Task 6: Modify, Plan, and Destroy

### Terraform Plan / Apply Symbols

*   **`+` (Plus)** → Create a new resource
*   **`-` (Minus)** → Destroy an existing resource
*   **`~` (Tilde)** → Update resource in place

```text
+ create
- destroy
~ update in place
```
