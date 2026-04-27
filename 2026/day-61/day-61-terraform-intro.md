Task 1: Understand Infrastructure as Code

**IaC** means managing infrastructure (servers, networks, databases) **using code instead of manual setup**.

**Why it matters in DevOps**

*   Automates infrastructure
*   Ensures consistency across environments
*   Enables version control, reviews, and CI/CD
*   Reduces human errors

**Problems IaC solves vs AWS Console**

*   Manual errors → automated, repeatable setups
*   No history → version‑controlled changes
*   Hard to recreate → easy environment replication
*   Slow provisioning → fast, scripted deployment

***

### Terraform vs Other Tools

*   **Terraform vs CloudFormation**
    *   Terraform: multi‑cloud
    *   CloudFormation: AWS‑only

*   **Terraform vs Ansible**
    *   Terraform: creates infrastructure
    *   Ansible: configures servers/software

*   **Terraform vs Pulumi**
    *   Terraform: simple declarative language (HCL)
    *   Pulumi: real programming languages

***

### Key Terraform Concepts

*   **Declarative**: Define *what you want*, Terraform decides *how to do it*
*   **Cloud‑agnostic**: Same tool for AWS, Azure, GCP, etc.

Task 2: Install Terraform and Configure AWS
Task 3: Your First Terraform Config -- Create an S3 Bucket
provider "aws" {
 region = "eu-north-1"
}

resource "aws_s3_bucket" "my-bucket" {
 bucket = "vishaldk18-new-bucket"
}



*   **`terraform init` downloads**: required **providers**, **modules**, and **backend plugins**.
*   **`.terraform/` directory**: local cache holding **provider binaries**, **module code**, and **backend metadata**.
*   ✅ Safe to delete; Terraform recreates it on next `terraform init`.


Task 4: Add an EC2 Instance

resource "aws_instance" "my-instance" {
 ami = "ami-0a0823e4ea064404d"
 instance_type = "t3.micro"
 tags = {
    Name = "TerraWeek-Day1"
 }
}



How does Terraform know the S3 bucket already exists and only the EC2 instance needs to be created?

Terraform knows because of **state + refresh from the provider API**.

### How it works:

1.  **Terraform state file (`terraform.tfstate`)**
    *   Records resources Terraform already manages (like the S3 bucket).
    *   If the bucket is in state, Terraform knows it exists.

2.  **State refresh (during `plan` / `apply`)**
    *   Terraform asks AWS: *“Does this resource exist and match the config?”*
    *   If the S3 bucket exists and matches → **no change**
    *   If the EC2 instance is missing → **mark for creation**

3.  **Execution plan**
    *   Terraform compares:
        *   **Desired config**
        *   **Current state**
        *   **Actual AWS infrastructure**
    *   Result: Only EC2 is created.

### In one line:

✅ **S3 exists in state and AWS → no action**  
✅ **EC2 missing → Terraform creates it**

If the S3 bucket existed **but was not in state**, Terraform would try to create it unless you `terraform import` it.



Task 5: Understand the State File

Here’s a **short explanation of each Terraform state command**:

```bash
terraform show
```

✅ Shows a **human‑readable view of the current Terraform state** (all managed resources and their attributes).

```bash
terraform state list
```

✅ Lists **all resources Terraform is currently managing** (from the state file).

```bash
terraform state show aws_s3_bucket.<name>
```

✅ Displays **detailed state information** for a specific S3 bucket.

```bash
terraform state show aws_instance.<name>
```

✅ Displays **detailed state information** for a specific EC2 instance.

### In short:

*   `show` → entire state summary
*   `state list` → resource names only
*   `state show` → deep details of one resource

These commands **read state only** and do **not change infrastructure**.


### What information does the Terraform state file store?

For **each resource**, the state file stores:

*   **Resource ID** (real ID in AWS, Azure, etc.)
*   **Resource type & name** (e.g., `aws_s3_bucket.logs`)
*   **Current attributes** (ARN, IPs, names, tags, etc.)
*   **Dependencies** between resources
*   **Provider metadata**

✅ Terraform uses this to map **code ↔ real infrastructure**.

***

### Why should you NEVER manually edit the state file?

*   High risk of **corrupting state**
*   Terraform may **destroy or recreate resources accidentally**
*   Breaks dependency tracking
*   Changes are **not validated**

✅ Always use Terraform commands:

```bash
terraform state mv
terraform state rm
terraform import
```

***

### Why should the state file NOT be committed to Git?

*   Contains **sensitive data**
    *   passwords
    *   secrets
    *   private IPs
*   Causes **merge conflicts** (state is environment‑specific)
*   Security risk if repo is leaked

✅ Best practice:

*   Store state in **remote backend** (S3 + DynamoDB, Terraform Cloud)
*   Add `terraform.tfstate*` to `.gitignore`

***

### One‑line summary

> The state file is Terraform’s **source of truth**—never edit it, never commit it, and always protect it.


Task 6: Modify, Plan, and Destroy

In Terraform plan/apply output, the symbols mean:


+ (Plus) → Create
A new resource will be created.


- (Minus) → Destroy
An existing resource will be deleted.


~ (Tilde) → Update in place
An existing resource will be modified without being recreated.
