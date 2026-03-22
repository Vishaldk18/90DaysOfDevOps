# 🚀 GitHub CLI (gh) Cheat Sheet

---

## 🔐 Authentication

```bash
gh auth login              # Login to GitHub
gh auth status             # Check login & scopes
gh auth refresh -s delete_repo   # Add permissions (like delete repo)
gh auth logout             # Logout
```

---

## 📦 Repository Management

```bash
gh repo create my-repo --public --clone
gh repo create my-repo --private --source=. --push

gh repo list               # List your repos
gh repo view               # View current repo details
gh repo view owner/repo    # View specific repo
gh repo view --web         # Open in browser

gh repo clone owner/repo   # Clone repo
gh repo fork owner/repo    # Fork repo

gh repo delete owner/repo --confirm   # Delete repo
```

---

## 🌿 Branch + PR (Pull Request)

```bash
gh pr create               # Create PR (interactive)
gh pr list                 # List PRs
gh pr view 1               # View PR details
gh pr checkout 1           # Checkout PR locally

gh pr merge 1              # Merge PR
gh pr close 1              # Close PR
```

---

## 🐞 Issues Management

```bash
gh issue create --title "Bug" --body "Details"
gh issue list
gh issue view 1
gh issue close 1
```

---

## 🔐 Secrets (CI/CD 🔥 Important)

```bash
gh secret set SECRET_NAME
gh secret list
```

👉 Used in GitHub Actions pipelines

---

## ⚙️ GitHub Actions / Workflows

```bash
gh workflow list
gh workflow view

gh workflow run workflow.yml     # Trigger workflow
gh run list                      # List runs
gh run view <run-id>             # View run details
gh run watch                     # Watch live logs
```

---

## 📦 Releases

```bash
gh release create v1.0.0 --notes "First release"
gh release list
gh release view v1.0.0
```

---

## 👤 User / Info

```bash
gh api user            # Get user info (API)
gh config list         # CLI config
```

---

## 🔎 Advanced (Automation Use)

```bash
gh repo view --json name,visibility
gh pr list --json title,state
```

👉 Used in scripts / CI/CD

---

## ⚡ Real DevOps Workflow Example

```bash
gh repo create devops-project --private --clone
cd devops-project

gh secret set AWS_ACCESS_KEY_ID
gh secret set AWS_SECRET_ACCESS_KEY

gh workflow run deploy.yml
gh run watch
```

---

## 🧠 Interview Summary

👉

> “GitHub CLI is used to automate repository management, PR workflows, secrets handling, and CI/CD operations. It helps integrate GitHub into DevOps pipelines.”

---

## 🔥 Must-Know Commands (Top 10)

If short on time, remember these:

```bash
gh auth login
gh repo create
gh repo view
gh repo delete
gh pr create
gh pr merge
gh issue create
gh secret set
gh workflow run
gh run watch
```

---
