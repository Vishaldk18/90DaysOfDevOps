# Day 09 Challenge - Linux User & Group Management
## Users & Groups Created

### Users

* tokyo
* berlin
* professor
* nairobi

### Groups

* developers
* admins
* project-team

---

## Group Assignments

| User      | Primary/Additional Groups |
| --------- | ------------------------- |
| tokyo     | developers, project-team  |
| berlin    | developers, admins        |
| professor | admins                    |
| nairobi   | project-team              |

---

## Directories Created

| Directory           | Group Owner  | Permissions |
| ------------------- | ------------ | ----------- |
| /opt/dev-project    | developers   | 775         |
| /opt/team-workspace | project-team | 775         |

---

## Commands Used

### Task 1: Create Users

```bash
sudo useradd -m tokyo
sudo useradd -m berlin
sudo useradd -m professor

sudo passwd tokyo
sudo passwd berlin
sudo passwd professor
```

Verify users:

```bash
grep "tokyo\|berlin\|professor" /etc/passwd
ls -l /home
```

---

### Task 2: Create Groups

```bash
sudo groupadd developers
sudo groupadd admins
```

Verify groups:

```bash
grep "developers\|admins" /etc/group
```

---

### Task 3: Assign Users to Groups

```bash
sudo usermod -aG developers tokyo

sudo usermod -aG developers berlin
sudo usermod -aG admins berlin

sudo usermod -aG admins professor
```

Verify membership:

```bash
groups tokyo
groups berlin
groups professor
```

---

### Task 4: Create Shared Development Directory

```bash
sudo mkdir -p /opt/dev-project

sudo chgrp developers /opt/dev-project

sudo chmod 775 /opt/dev-project
```

Verify:

```bash
ls -ld /opt/dev-project
```

Test file creation:

```bash
sudo -u tokyo touch /opt/dev-project/tokyo-file.txt

sudo -u berlin touch /opt/dev-project/berlin-file.txt

ls -l /opt/dev-project
```

---

### Task 5: Create Team Workspace

Create user and group:

```bash
sudo useradd -m nairobi
sudo passwd nairobi

sudo groupadd project-team
```

Add users to project-team:

```bash
sudo usermod -aG project-team nairobi
sudo usermod -aG project-team tokyo
```

Create workspace:

```bash
sudo mkdir -p /opt/team-workspace

sudo chgrp project-team /opt/team-workspace

sudo chmod 775 /opt/team-workspace
```

Verify:

```bash
ls -ld /opt/team-workspace
```

Test access:

```bash
sudo -u nairobi touch /opt/team-workspace/nairobi-file.txt

ls -l /opt/team-workspace
```

---

## Verification Commands

### Check User Details

```bash
id tokyo
id berlin
id professor
id nairobi
```

### Check Groups

```bash
cat /etc/group | grep -E "developers|admins|project-team"
```

### Check Directory Permissions

```bash
ls -ld /opt/dev-project
ls -ld /opt/team-workspace
```
