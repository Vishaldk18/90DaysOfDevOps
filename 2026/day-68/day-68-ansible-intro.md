# Task 1: Understand Ansible

***

# ✅ 1. What is Configuration Management? Why do we need it?

## 🔹 Definition

**Configuration Management (CM)** is the process of **automating and maintaining the desired state of systems** (servers, software, configurations) in a consistent and repeatable way.

***

## 🔹 Why do we need it?

Without CM:

*   Manual server setup ❌
*   Inconsistent environments ❌
*   Human errors ❌
*   Difficult scaling ❌

With CM tools (like Ansible):

*   ✅ Consistent server configuration
*   ✅ Automation (no manual work)
*   ✅ Faster deployments
*   ✅ Reduced errors
*   ✅ Easy scaling (manage 1 → 1000 servers)

***

## 🔹 Example

Instead of manually installing Nginx on 10 servers:

👉 You define:

```yaml
- name: Install nginx
  apt:
    name: nginx
    state: present
```

And Ansible applies it everywhere ✅

***

# ✅ 2. How is Ansible different from Chef, Puppet, and Salt?

| Feature        | Ansible         | Chef        | Puppet      | Salt                 |
| -------------- | --------------- | ----------- | ----------- | -------------------- |
| Architecture   | Agentless ✅     | Agent-based | Agent-based | Agent-based (mostly) |
| Language       | YAML (simple) ✅ | Ruby        | Custom DSL  | YAML/Python          |
| Setup          | Easy ✅          | Complex     | Complex     | Medium               |
| Learning curve | Low ✅           | High        | High        | Medium               |
| Communication  | SSH ✅           | Agent       | Agent       | Agent / SSH          |
| Push vs Pull   | Push ✅          | Pull        | Pull        | Both                 |

***

## 🔹 Key differences

### ✅ Ansible

*   No agent needed
*   Uses SSH
*   Very simple YAML syntax
*   Best for beginners & quick automation

***

### 🔸 Chef

*   Uses Ruby DSL
*   Requires agent ("Chef Client")
*   More complex but powerful

***

### 🔸 Puppet

*   Uses its own DSL
*   Agent-based model
*   Good for large enterprise environments

***

### 🔸 SaltStack

*   Fast (event-driven)
*   Can work agentless or agent-based
*   Slightly more complex than Ansible

***

✅ **Summary:**

> Ansible is easiest, fastest to start, and requires no agents.

***

# ✅ 3. What does "agentless" mean?

## 🔹 Meaning

**Agentless = No software needs to be installed on target servers**

***

## 🔹 How Ansible connects?

Ansible uses:

*   ✅ SSH (Linux)
*   ✅ WinRM (Windows)

***

## 🔹 Process

1.  You run Ansible command
2.  Ansible connects via SSH
3.  Executes task
4.  Returns result

***

### ✅ Example

```bash
ansible servers -m ping
```

➡️ Internally:

*   SSH → server
*   Run Python-based module
*   Return `"pong"`

***

✅ No daemon, no agent, no extra setup on remote nodes.

***

# ✅ 4. Ansible Architecture (Simple Explanation)

## 🔹 Diagram (conceptual)

              Control Node
            (Ansible installed)
                   |
            --------------------
            |        |        |
       Managed   Managed   Managed
        Node1     Node2     Node3

***

## 🔹 Components Explained

### ✅ 1. Control Node

*   Machine where Ansible runs
*   Example:
    *   Your laptop 💻
    *   EC2 instance (like yours)

👉 It:

*   Executes playbooks
*   Connects to servers via SSH

***

### ✅ 2. Managed Nodes

*   Target machines
*   Example:
    *   EC2 instances
    *   Linux servers

👉 They:

*   Receive instructions
*   Execute tasks

***

### ✅ 3. Inventory

*   List of servers

Example:

```ini
[servers]
server1 ansible_host=13.60.21.179
server2 ansible_host=13.48.148.184
```

👉 Defines:

*   Hostnames
*   IP addresses
*   Groups

***

### ✅ 4. Modules

*   Small programs that perform tasks

Examples:

*   `apt` → install packages
*   `copy` → copy files
*   `service` → start/stop services

Example:

```bash
ansible servers -m apt -a "name=nginx state=present"
```

***

### ✅ 5. Playbooks

*   YAML files defining automation

Example:

```yaml
- name: Install Nginx
  hosts: servers
  become: yes

  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
```

👉 Playbooks:

*   Define **what to do**
*   On **which servers**

***

## ✅ Full Flow

    1. You write Playbook
    2. Define Inventory
    3. Run ansible-playbook
    4. Control Node connects via SSH
    5. Executes Modules on Managed Nodes
    6. Returns results

***

# ✅ Final Summary

*   Configuration Management = automating system setup ✅
*   Ansible = simple, agentless, SSH-based ✅
*   No agent needed → easier setup ✅
*   Architecture:
    *   Control Node → runs Ansible
    *   Managed Nodes → target servers
    *   Inventory → server list
    *   Modules → tasks
    *   Playbooks → automation logic ✅

***

### Task 2: Set Up Your Lab Environment
You need 2-3 EC2 instances to practice on. Choose one approach:

**Option A: Use Terraform (recommended -- you just learned this)**
Use your TerraWeek skills to provision 3 EC2 instances with:
- Amazon Linux 2 or Ubuntu 22.04
- `t2.micro` instance type
- A security group allowing SSH (port 22)
- A key pair for SSH access

**Option B: Launch manually from AWS Console**
Create 3 instances with the same specs above.

Label them mentally:
- **Instance 1:** web server
- **Instance 2:** app server
- **Instance 3:** db server

Verify you can SSH into each one from your control node:
```bash
ssh -i ~/your-key.pem ec2-user@<public-ip-1>
ssh -i ~/your-key.pem ec2-user@<public-ip-2>
ssh -i ~/your-key.pem ec2-user@<public-ip-3>
```

---

### Task 3: Install Ansible
Install Ansible on your **control node** (your laptop or one dedicated EC2 instance):

```bash
# macOS
brew install ansible

# Ubuntu/Debian
sudo apt update
sudo apt install ansible -y

# Amazon Linux / RHEL
sudo yum install ansible -y
# or
pip3 install ansible

# Verify
ansible --version
```

Confirm the output shows the Ansible version, config file path, and Python version.

***
**Document:** On which machine did you install Ansible? Why is it only needed on the control node?
Ansible is needed only on the control node because it is designed to work using an agentless architecture, which means there is no requirement to install any software or agent on the managed nodes. The control node directly connects to the target machines using SSH, which is already available on most Linux systems. When a task is executed, Ansible sends small pieces of code called modules to the managed nodes, runs them temporarily using Python, and then removes them after execution. Because of this push-based mechanism, all the processing and orchestration happen on the control node itself, while the managed nodes simply execute the instructions they receive and return the results. This approach reduces setup complexity, avoids maintaining agents on multiple servers, and makes Ansible lightweight and easy to use.
***

# Default Host file template
***
[servers]
server1 ansible_host=13.51.197.8
server2 ansible_host=16.170.205.70

[servers:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/ubuntu/keys/ansible-demo
ansible_python_interpreter=/usr/bin/python3
ansible_host_key_checking=false
***

---
