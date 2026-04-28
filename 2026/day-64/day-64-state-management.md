## ✅ Task 1: Inspect Your Current State

### 1️⃣ How many resources does Terraform track?
Terraform tracks **all resource instances present in the state file**.  
Each resource (and each `count` / `for_each` instance) has a separate entry in the state.

---

### 2️⃣ What attributes does the state store for an EC2 instance?
Terraform stores many attributes returned by AWS, including:

- Instance ID  
- ARN  
- AMI  
- Instance type  
- Public & private IPs  
- DNS names  
- Subnet ID  
- Security groups  
- Tags  
- Lifecycle metadata  

---

### 3️⃣ What does the serial number in `terraform.tfstate` represent?
The **serial number** is the **state version**.  
It increments **every time the state file is updated**.

---

## ✅ Task 2: Set Up S3 Remote Backend

Remote backend configured using **S3** with **DynamoDB** for state locking to safely support team collaboration.

---

## ✅ Task 3: Test State Locking

### Observed Error Message

```

Error: Error acquiring the state lock

Error message: operation error DynamoDB: PutItem, https response error StatusCode: 400, RequestID:
93KA2L152RCEJ8OPICJ255O9ERVV4KQNSO5AEMVJF66Q9ASUAAJG, ConditionalCheckFailedException: The conditional request failed

Lock Info:
ID:        a171a153-f9f3-dac8-dc71-550687d039aa
Path:      terraweek-state-vishal/dev/terraform.tfstate
Operation: OperationTypeApply
Who:       ubuntu\@ip-172-31-19-46
Version:   1.14.9
Created:   2026-04-28 07:40:11.106673481 +0000 UTC

````

### Why State Locking Is Critical in Team Environments
- Prevents **simultaneous writes** to the state file
- Avoids **state corruption**
- Ensures **only one apply operation** happens at a time
- Essential when **multiple engineers** work on the same infrastructure

---

## ✅ Task 4: Import an Existing Resource

### Conceptual Difference

- **Create from scratch** → Terraform creates a new resource and then manages it
- **terraform import** → Terraform starts managing an existing resource  
  (updates **state only**, not the code)

---

### 1️⃣ Create a Resource from Scratch

Terraform **creates** the resource.

```hcl
# main.tf
resource "aws_s3_bucket" "new_bucket" {
  bucket = "my-new-bucket-123"
}
````

```bash
terraform apply
```

✅ Bucket is **created by Terraform**  
✅ State is automatically updated

***

### 2️⃣ `terraform import`

Terraform **manages an existing resource** (does **not** create it).

```hcl
# main.tf (must already exist)
resource "aws_s3_bucket" "existing_bucket" {
  bucket = "my-existing-bucket"
}
```

```bash
terraform import aws_s3_bucket.existing_bucket my-existing-bucket
```

✅ Bucket already existed  
✅ Terraform adds it to **state only**

***

### One-line Difference

*   **Create** → Terraform **creates + manages**
*   **Import** → Terraform **only manages** an existing resource

***

## ✅ Task 5: State Surgery – `mv` and `rm`

### 🔁 `terraform state mv`

✅ Used when **renaming or moving a resource in code**  
✅ Keeps the same real infrastructure

```bash
terraform state mv aws_instance.old aws_instance.new
```

**Real use case:**  
Refactoring modules, renaming resources, reorganizing Terraform structure.

***

### ❌ `terraform state rm`

✅ Used when Terraform should **stop managing a resource**  
✅ Does **NOT delete** the real resource

```bash
terraform state rm aws_instance.example
```

**Real use case:**  
Handing a resource back to manual control or preparing it for re-import.

***

### One-line Summary

*   **state mv** → *“Same resource, new address”*
*   **state rm** → *“Forget this resource, but don’t delete it”*

***

## ✅ Task 6: Simulate and Fix State Drift

### How Teams Prevent State Drift in Production

*   **Blocking manual changes**  
    IAM policies restrict console changes

*   **Mandatory CI/CD applies**  
    Only pipelines run `terraform apply`

*   **Regular `terraform plan` checks**  
    Scheduled drift detection

*   **Remote state + locking**  
    S3/GCS/Azure backends with locking

*   **Code reviews & approvals**  
    PR-based infrastructure changes

*   **Drift detection tools**  
    Terraform Cloud, Atlantis, scheduled jobs

*   **Properly importing legacy resources**  
    Avoid unmanaged infrastructure

***

### One-line Summary

> Lock down production, automate applies, and continuously compare real infrastructure with Terraform state.
