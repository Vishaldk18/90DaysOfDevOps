### 1. `terraform init`

✅ Initializes the Terraform project

*   Downloads providers and modules
*   Sets up backend and state

```bash
terraform init
```

***

### 2. `terraform validate`

✅ Checks configuration syntax

*   Verifies `.tf` files are valid
*   No infrastructure changes

```bash
terraform validate
```

***

### 3. `terraform plan`

✅ Shows what Terraform *will* do

*   Compares config with state and real infra
*   No resources are created/changed

```bash
terraform plan
```

***

### 4. `terraform apply`

✅ Creates or updates infrastructure

*   Executes the plan
*   Asks for confirmation

```bash
terraform apply
```

Skip confirmation:

```bash
terraform apply -auto-approve
```

***

### 5. `terraform destroy`

✅ Deletes all managed resources

```bash
terraform destroy
```

***

### 6. `terraform show`

✅ Displays current state in readable form

```bash
terraform show
```

***

### 7. `terraform state list`

✅ Lists all resources Terraform manages

```bash
terraform state list
```

***

### 8. `terraform state show <resource>`

✅ Shows details of a specific resource

```bash
terraform state show aws_instance.web
```

***

### 9. `terraform fmt`

✅ Formats Terraform code

*   Makes `.tf` files clean and consistent

```bash
terraform fmt
```

***

### 10. `terraform output`

✅ Displays output values

```bash
terraform output
```

***

### Basic Terraform Workflow

```text
terraform init
terraform validate
terraform plan
terraform apply
```

***

✅ These commands cover **90% of daily Terraform usage** in DevOps.
