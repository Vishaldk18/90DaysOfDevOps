# Day 11 Challenge - File Ownership (chown & chgrp)

## Objective

Learn how Linux file ownership works and practice changing file owners and groups using `chown` and `chgrp`.

---

# Task 1: Understanding Ownership

## Check Ownership

```bash
ls -l
```

Example Output:

```text
-rw-r--r-- 1 vishal vishal 0 Jun 15 10:00 devops-file.txt
```

Format:

```text
-rw-r--r-- 1 owner group size date filename
```

### Difference Between Owner and Group

* **Owner**: The user who owns the file and has primary control over it.
* **Group**: A collection of users who may share access to the file based on group permissions.

Example:

```text
-rw-r--r-- 1 tokyo developers devops-file.txt
```

* Owner = tokyo
* Group = developers

---

# Task 2: Basic chown Operations

## Create File

```bash
touch devops-file.txt
```

## Check Current Ownership

```bash
ls -l devops-file.txt
```

Example:

```text
-rw-r--r-- 1 vishal vishal devops-file.txt
```

## Change Owner to tokyo

```bash
sudo chown tokyo devops-file.txt
```

Verify:

```bash
ls -l devops-file.txt
```

Output:

```text
-rw-r--r-- 1 tokyo vishal devops-file.txt
```

## Change Owner to berlin

```bash
sudo chown berlin devops-file.txt
```

Verify:

```bash
ls -l devops-file.txt
```

Output:

```text
-rw-r--r-- 1 berlin vishal devops-file.txt
```

---

# Task 3: Basic chgrp Operations

## Create File

```bash
touch team-notes.txt
```

## Create Group

```bash
sudo groupadd heist-team
```

## Check Current Group

```bash
ls -l team-notes.txt
```

## Change Group

```bash
sudo chgrp heist-team team-notes.txt
```

Verify:

```bash
ls -l team-notes.txt
```

Output:

```text
-rw-r--r-- 1 vishal heist-team team-notes.txt
```

---

# Task 4: Combined Owner & Group Change

## Create File

```bash
touch project-config.yaml
```

## Change Owner and Group Together

```bash
sudo chown professor:heist-team project-config.yaml
```

Verify:

```bash
ls -l project-config.yaml
```

Output:

```text
-rw-r--r-- 1 professor heist-team project-config.yaml
```

---

## Create Directory

```bash
mkdir app-logs
```

## Change Ownership

```bash
sudo chown berlin:heist-team app-logs
```

Verify:

```bash
ls -ld app-logs
```

Output:

```text
drwxr-xr-x 2 berlin heist-team app-logs
```

---

# Task 5: Recursive Ownership

## Create Directory Structure

```bash
mkdir -p heist-project/vault
mkdir -p heist-project/plans

touch heist-project/vault/gold.txt
touch heist-project/plans/strategy.conf
```

## Create Group

```bash
sudo groupadd planners
```

## Apply Recursive Ownership

```bash
sudo chown -R professor:planners heist-project
```

Verify:

```bash
ls -lR heist-project
```

Example Output:

```text
heist-project:
drwxr-xr-x professor planners plans
drwxr-xr-x professor planners vault

heist-project/plans:
-rw-r--r-- professor planners strategy.conf

heist-project/vault:
-rw-r--r-- professor planners gold.txt
```

---

# Task 6: Practice Challenge

## Create Groups

```bash
sudo groupadd vault-team
sudo groupadd tech-team
```

## Create Directory

```bash
mkdir bank-heist
```

## Create Files

```bash
touch bank-heist/access-codes.txt
touch bank-heist/blueprints.pdf
touch bank-heist/escape-plan.txt
```

## Set Ownership

### access-codes.txt

```bash
sudo chown tokyo:vault-team bank-heist/access-codes.txt
```

### blueprints.pdf

```bash
sudo chown berlin:tech-team bank-heist/blueprints.pdf
```

### escape-plan.txt

```bash
sudo chown nairobi:vault-team bank-heist/escape-plan.txt
```

## Verify

```bash
ls -l bank-heist
```

Example Output:

```text
-rw-r--r-- 1 tokyo   vault-team access-codes.txt
-rw-r--r-- 1 berlin  tech-team  blueprints.pdf
-rw-r--r-- 1 nairobi vault-team escape-plan.txt
```

---

# Files & Directories Created

## Files

* devops-file.txt
* team-notes.txt
* project-config.yaml
* heist-project/vault/gold.txt
* heist-project/plans/strategy.conf
* bank-heist/access-codes.txt
* bank-heist/blueprints.pdf
* bank-heist/escape-plan.txt

## Directories

* app-logs
* heist-project
* heist-project/vault
* heist-project/plans
* bank-heist

---

# Ownership Changes

| File/Directory      | Before        | After                |
| ------------------- | ------------- | -------------------- |
| devops-file.txt     | vishal:vishal | berlin:vishal        |
| team-notes.txt      | vishal:vishal | vishal:heist-team    |
| project-config.yaml | vishal:vishal | professor:heist-team |
| app-logs            | vishal:vishal | berlin:heist-team    |
| heist-project       | vishal:vishal | professor:planners   |
| access-codes.txt    | vishal:vishal | tokyo:vault-team     |
| blueprints.pdf      | vishal:vishal | berlin:tech-team     |
| escape-plan.txt     | vishal:vishal | nairobi:vault-team   |

---

# Commands Used

```bash
ls -l

touch devops-file.txt

sudo chown tokyo devops-file.txt
sudo chown berlin devops-file.txt

touch team-notes.txt
sudo groupadd heist-team
sudo chgrp heist-team team-notes.txt

touch project-config.yaml
sudo chown professor:heist-team project-config.yaml

mkdir app-logs
sudo chown berlin:heist-team app-logs

mkdir -p heist-project/vault
mkdir -p heist-project/plans

touch heist-project/vault/gold.txt
touch heist-project/plans/strategy.conf

sudo groupadd planners
sudo chown -R professor:planners heist-project

sudo groupadd vault-team
sudo groupadd tech-team

mkdir bank-heist

touch bank-heist/access-codes.txt
touch bank-heist/blueprints.pdf
touch bank-heist/escape-plan.txt

sudo chown tokyo:vault-team bank-heist/access-codes.txt
sudo chown berlin:tech-team bank-heist/blueprints.pdf
sudo chown nairobi:vault-team bank-heist/escape-plan.txt

ls -l bank-heist
```

---

# Screenshots

Add screenshots for:

1. Initial ownership using `ls -l`
2. `chown` owner changes
3. `chgrp` group changes
4. Combined owner and group changes
5. Recursive ownership using `chown -R`
6. Final ownership of files inside `bank-heist`
7. Output of `ls -lR heist-project`

---

# What I Learned

1. Every file and directory in Linux has an owner and a group.
2. `chown` is used to change ownership, while `chgrp` changes group ownership.
3. Recursive ownership changes using `chown -R` are useful when managing entire application directories.

---

# Conclusion

Successfully practiced Linux file ownership management using `chown`, `chgrp`, and recursive ownership changes. These concepts are essential for DevOps tasks such as deployments, shared directories, CI/CD artifacts, and log management.
