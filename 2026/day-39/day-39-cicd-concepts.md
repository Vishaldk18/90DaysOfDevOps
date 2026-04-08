# 🧩 Task 1: The Problem

Think about a team of 5 developers all pushing code to the same repo manually deploying to production.

## ❓ What can go wrong?

* 5 developers all pushing to same repo will lead to:

  * Conflicts
  * Inconsistent code repo
  * Broken pipeline
  * Downtime

## ❓ What does "it works on my machine" mean and why is it a real problem?

* Means the code works locally on developer's machine
* Fails on production/remote server due to inconsistent environment

## ❓ How many times a day can a team safely deploy manually?

* Not sure

---

# 🔄 Task 2: CI vs CD

## ✅ Continuous Integration (CI)

**Answer:**

Continuous Integration is the practice of frequently merging code changes from multiple developers into a shared repository, where each change is automatically built and tested.
This helps detect bugs, integration issues, and broken builds early in the development cycle.

---

## 🚀 Continuous Delivery (CD)

**Answer:**

Continuous Delivery is an extension of Continuous Integration where the application is automatically built, tested, and prepared for release to production.
The deployment to production is a manual decision, ensuring the system is always in a deployable state.

---

## ⚡ Continuous Deployment

**Answer:**

Continuous Deployment takes Continuous Delivery one step further by automatically deploying every change that passes all tests directly to production without any manual intervention.
This enables faster releases and continuous feedback from users.

---

## 🌍 Real-World Examples

### ✅ 1. Continuous Integration (CI)

**🎯 Interview Answer:**

Continuous Integration is a DevOps practice where developers frequently merge their code changes into a shared repository, and each change is automatically built and tested. This helps detect integration issues, bugs, and conflicts early in the development cycle.

**🌍 Example:**

* 5 developers push code daily to GitHub
* Every push triggers a pipeline:

  * Build the app
  * Run unit tests
  * Check code quality

👉 If a test fails, the build breaks immediately — preventing bad code from being merged.

---

### 🚀 2. Continuous Delivery

**🎯 Interview Answer:**

Continuous Delivery is a practice where code changes are automatically built, tested, and prepared for release to production. The application is always in a deployable state, but the final deployment to production requires manual approval.

**🌍 Example:**

* Code passes CI pipeline
* Automatically deployed to staging environment
* QA team tests it
* Team clicks **“Deploy to Production”**

👉 System is always ready, but humans decide when to release.

---

### ⚡ 3. Continuous Deployment

**🎯 Interview Answer:**

Continuous Deployment is an extension of Continuous Delivery where every change that passes automated tests is automatically deployed to production without any manual intervention.

**🌍 Example:**

* Developer pushes code
* Pipeline runs tests
* If everything passes → automatically released to users

👉 No approval step — continuous updates.

---

## 🧠 Quick Summary

Continuous Integration focuses on integrating and testing code frequently.
Continuous Delivery ensures the application is always ready for deployment with a manual approval step.
Continuous Deployment automates the entire process including releasing to production.

---

# 🔧 Task 3: Pipeline Anatomy

## 🚀 1. Trigger

> A trigger is the event that starts the pipeline.

**What it does:**

* Initiates the pipeline automatically
* Common triggers:

  * Code push
  * Pull request
  * Scheduled job
  * Manual trigger

👉 Developer pushes code → pipeline starts automatically

---

## 🧱 2. Stage

> A stage is a logical grouping of related jobs.

**What it does:**

* Divides pipeline into phases
* Helps organize workflow

**Common stages:**

* Build
* Test
* Deploy

---

## ⚙️ 3. Job

> A job is a unit of work inside a stage.

**What it does:**

* Runs steps on a runner
* Can run in parallel

---

## 🪜 4. Step

> A step is a single command inside a job.

**Examples:**

* `npm install`
* `docker build`
* `pytest`

---

## 🖥️ 5. Runner

> A runner is the machine executing jobs.

**Types:**

* Hosted
* Self-hosted

---

## 📦 6. Artifact

> Output produced by a job.

**Examples:**

* `.jar`, `.zip`
* Docker image
* Test reports

👉 Build → Artifact → Deploy

---

## 🧠 Summary

A pipeline is triggered by events like commits.
It has stages (build, test, deploy), containing jobs.
Jobs run on runners and consist of steps.
Artifacts are outputs passed between stages.

---

# 🚀 Task 4: Pipeline Flow

```
Developer Push (GitHub)
        ↓
Trigger Pipeline
        ↓
Checkout Code
        ↓
Test Stage
  - Run unit tests
  - Lint code
        ↓
Build Stage
  - Build Docker image
  - Tag image
        ↓
Push Stage (optional but common)
  - Push image to Docker Hub / ECR
        ↓
Deploy Stage
  - Pull image on staging server
  - Run container
```

---

# 🌍 Task 5: Explore in the Wild

Repository explored: Docker

## 🔍 Findings

**Trigger:**

* On push to main branches
* Workflow dispatch
* Pull requests

**Jobs:**

* 8 jobs

**What it does:**

* CI pipeline for Docker
* Includes:

  * Code validation
  * Binary build
  * Image testing
  * End-to-end tests
  * Coverage
  * Release

