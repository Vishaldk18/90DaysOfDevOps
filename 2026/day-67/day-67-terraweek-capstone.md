# Task 1: Learn Terraform Workspaces

```bash
mkdir terraweek-capstone && cd terraweek-capstone
terraform init

# See current workspace
terraform workspace show                    # default

# Create new workspaces
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# List all workspaces
terraform workspace list

# Switch between them
terraform workspace select dev
terraform workspace select staging
terraform workspace select prod
```

## 1️⃣ What does `terraform.workspace` return?

`terraform.workspace` returns the **name of the currently selected Terraform workspace**.

Example:

```hcl
locals {
  env = terraform.workspace
}
```

If you run:

```bash
terraform workspace select prod
```

Then inside the config:

```hcl
terraform.workspace == "prod"
```

✅ Common uses:

*   Naming resources
*   Switching sizes/counts per environment
*   Environment‑specific tagging

```hcl
tags = {
  Environment = terraform.workspace
}
```

***

## 2️⃣ Where does each workspace store its state file?

Terraform stores **one state file per workspace**.

### Local backend (default)

    terraform.tfstate.d/
    ├── dev/
    │   └── terraform.tfstate
    ├── stage/
    │   └── terraform.tfstate
    └── prod/
        └── terraform.tfstate

Each workspace:

*   Uses the **same configuration**
*   But has **isolated state**

### Remote backend (e.g., S3)

State files are separated by workspace name:

    s3://my-bucket/eks/terraform.tfstate          (default)
    s3://my-bucket/eks/env:/dev/terraform.tfstate
    s3://my-bucket/eks/env:/prod/terraform.tfstate

👉 Terraform automatically handles this layout.

***

## 3️⃣ How is this different from separate directories per environment?

### 🟦 Terraform Workspaces

**One directory, one config, multiple states**

✅ Pros:

*   Less code duplication
*   Easy to switch environments
*   Same module versions everywhere

❌ Cons:

*   Easy to accidentally run `apply` in wrong workspace
*   Harder to customize environments deeply
*   Not great for very large teams

**Best for:** small–medium projects, similar environments

***

### 🟩 Separate Directories (recommended for prod systems)

**One directory per environment**

    envs/
    ├── dev/
    ├── stage/
    └── prod/

✅ Pros:

*   Very explicit and safe
*   Different variables, modules, providers
*   Clear Git history and approvals
*   Preferred by Terraform & AWS best practices

❌ Cons:

*   More files
*   Slight duplication (usually solved with modules)

**Best for:** production, regulated, multi‑team environments

***

## 4️⃣ Key differences (quick view)

| Aspect                 | Workspaces   | Separate Directories |
| ---------------------- | ------------ | -------------------- |
| State isolation        | ✅ Yes        | ✅ Yes                |
| Code isolation         | ❌ No         | ✅ Yes                |
| Risk of mistakes       | Higher       | Lower                |
| Customization          | Limited      | Full                 |
| Industry best practice | ⚠️ Sometimes | ✅ Yes                |

***

## ✅ Summary

*   `terraform.workspace` → returns current workspace name
*   Each workspace → has its **own state file**
*   Workspaces ≠ environments (they only isolate state)
*   **Use workspaces** for simple or demo setups
*   **Use separate directories** for real production systems

> 💡 Rule of thumb:  
> **If prod matters → don’t use workspaces for isolation**

***

### Task 2: Set Up the Project Structure
Create this layout:

```
terraweek-capstone/
  main.tf                   # Root module -- calls child modules
  variables.tf              # Root variables
  outputs.tf                # Root outputs
  providers.tf              # AWS provider and backend
  locals.tf                 # Local values using workspace
  dev.tfvars                # Dev environment values
  staging.tfvars            # Staging environment values
  prod.tfvars               # Prod environment values
  .gitignore                # Ignore state, .terraform, tfvars with secrets
  modules/
    vpc/
      main.tf
      variables.tf
      outputs.tf
    security-group/
      main.tf
      variables.tf
      outputs.tf
    ec2-instance/
      main.tf
      variables.tf
      outputs.tf
```

Create the `.gitignore`:
```
.terraform/
*.tfstate
*.tfstate.backup
*.tfvars
.terraform.lock.hcl
```
---

### 📘 Why this Terraform file structure is considered **best practice**

This structure follows **Terraform and industry‑proven conventions** for building **scalable, safe, and maintainable infrastructure**.

***

## ✅ 1. Clear separation of responsibilities

*   **Root module (`main.tf`)** orchestrates resources
*   **Child modules (`modules/`)** encapsulate reusable logic (VPC, SG, EC2)
*   Each file has a *single purpose* (providers, variables, outputs)

➡️ Makes the code easier to understand and debug.

***

## ✅ 2. Reusability and DRY principle

*   Modules can be reused across:
    *   dev / staging / prod
    *   different projects
*   Avoids copy‑pasting infrastructure code

➡️ Changes in one module improve all environments.

***

## ✅ 3. Environment isolation without duplication

*   `dev.tfvars`, `staging.tfvars`, `prod.tfvars`  
    → same code, different values
*   Works cleanly with **Terraform workspaces**

➡️ Consistent infra with environment‑specific configuration.

***

## ✅ 4. Safer production workflow

*   Explicit environments reduce accidental changes
*   Supports approvals, CI/CD pipelines, and access controls

➡️ Aligns with real‑world production standards.

***

## ✅ 5. Scales with team size

*   Teams can own modules independently
*   Easier code reviews and collaboration
*   Predictable file locations

➡️ Essential for medium to large teams.

***

## ✅ 6. Secure by default (`.gitignore`)

Prevents committing:

*   State files
*   Provider lock/cache
*   Sensitive `.tfvars`

➡️ Protects secrets and avoids state corruption.

***

## ✅ 7. Industry‑standard and future‑proof

*   Matches Terraform documentation examples
*   Easily extendable (add RDS, EKS, ALB modules)
*   Compatible with CI/CD and remote backends

***

### ✅ Summary

This structure is best practice because it is:

*   ✅ Modular
*   ✅ Reusable
*   ✅ Secure
*   ✅ Environment‑aware
*   ✅ Scalable
*   ✅ Production‑ready

> **Rule of thumb:**  
> *If infrastructure will grow or touch production → use this structure.*



