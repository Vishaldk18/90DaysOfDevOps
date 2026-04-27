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


