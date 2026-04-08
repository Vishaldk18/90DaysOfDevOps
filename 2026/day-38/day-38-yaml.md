# 📄 YAML Practice Notes – DevOps Basics

## 📌 Task 1: Key-Value Pairs (`person.yaml`)

```yaml
name: vishal
role: devops-engineer
experience_years: 3
learning: true
```

### 🔹 Key Learnings:

* YAML uses `key: value` format
* Values can be **string, number, boolean**
* No quotes needed unless special characters are used

---

## 📌 Task 2: Lists

```yaml
tools:
  - git/github
  - docker
  - k8s
  - jira
  - aws
  - grafana

hobbies: [traveling, cricket, music, reading]
```

### 🔹 Key Learnings:

* Lists can be written in:

  * **Block format** (`- item`)
  * **Inline format** (`[item1, item2]`)
* Indentation is important for structure

---

## 📌 Task 3: Nested Objects (`server.yaml`)

```yaml
server:
  name: demo
  ip: 10.0.0.0
  port: 80

database:
  host: localhost
  name: mydb
  credentials:
    user: root
    password: test@123
```

### 🔹 Key Learnings:

* YAML supports **nested structures using indentation**
* Used heavily in:

  * Kubernetes
  * Docker Compose
  * Terraform configs

---

## 📌 Task 4: Multi-line Strings

### ✅ Using `|` (Literal Style – preserves formatting)

```yaml
startup_script: |
  echo "this is example of multiline string"
  echo "here pipe | is used, it's ideal for scripts"
  sudo apt upgrade
  sudo apt install -y nginx
  echo "each line executed one by one"
```

👉 Best for:

* Bash scripts
* Config files
* Commands execution

---

### ✅ Using `>` (Folded Style – converts to single line)

```yaml
extra_details: >
  this is a long message
  it will be treated as single line separated by space
```

👉 Output:

```
this is a long message it will be treated as single line separated by space
```

👉 Best for:

* Descriptions
* Messages
* Documentation text

---

## ⚠️ Important Rule

❌ YAML does NOT support tabs
✅ Always use **spaces (2 spaces recommended)**

---

# 🧠 What I Learned (Key Takeaways)

1. **Indentation is everything in YAML**
   → Defines structure (like Python)

2. **Use `|` for scripts and `>` for text**
   → Wrong usage can break real DevOps workflows

3. **YAML is widely used in DevOps tools**
   → Kubernetes, Docker Compose, GitHub Actions, CI/CD pipelines

---

# 🚀 Bonus (Interview Line)

> YAML is a human-readable data serialization language that relies on indentation to define structure and is widely used in DevOps for configuration management.
