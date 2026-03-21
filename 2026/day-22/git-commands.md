# 📘 Git Commands Cheat Sheet

---

# ⚙️ Setup & Config Commands

## 🔹 View Global Config
```bash
git config --global --list
````

👉 Shows global Git configuration (username, email, etc.)

---

## 🔹 Set Username

```bash
git config --global user.name "your username"
```

---

## 🔹 Set Email

```bash
git config --global user.email "your email"
```

---

# 🔄 Basic Workflow

## 📌 Steps

1. Create a folder
2. Initialize Git:

```bash
git init
```

3. Create a sample file

4. Add file to staging area:

```bash
git add sample_file
```

👉 File is now in **staging area (not yet committed)**

5. Commit the file:

```bash
git commit -m "message"
```

👉 File is now **tracked**

---

## 🧠 Summary

* `git add` → staging
* `git commit` → tracking

---

# 🔍 Viewing Changes

## 🔹 Check Status

```bash
git status
```

👉 Shows:

* Tracked / untracked files
* Staged changes

---

## 🔹 View Commit History

```bash
git log
```

👉 Shows commit logs and commit hashes

---

# 🌿 Branching Commands

## 🔹 View Branches

```bash
git branch
```

* `-a` → show all (local + remote)
* `-r` → show remote only

---

## 🔹 Create Branch

```bash
git branch <branch-name>
```

---

## 🔹 Switch Branch

```bash
git checkout <branch-name>
# or
git switch <branch-name>
```

---

## 🔹 Create + Switch Branch

```bash
git checkout -b <branch-name>
# or
git switch -c <branch-name>
```

---

## 🔹 Delete Branch

```bash
git branch -d <branch-name>
```

---

## 🔹 Rename Branch to main

```bash
git branch -M main
```

---

# 🌐 Remote Repository Commands

## 🔹 View Remote Repositories

```bash
git remote -v
```

👉 Shows linked remote repositories with fetch/push URLs

---

## 🔹 Push Code to Remote

```bash
git push -u origin main
```

### 📌 Explanation:

* `git push` → Upload local commits
* `-u` → Set upstream tracking
* `origin` → Remote name
* `main` → Branch name

---

## 🔹 Add Upstream Repository

```bash
git remote add upstream <original-repo-url>
```

---

## 🔹 Fetch from Upstream

```bash
git fetch upstream
```

---

## 🔹 Merge Upstream Changes

```bash
git merge upstream/main
```

---

## 🔹 Push Changes to Origin

```bash
git push origin main
```

---

# 🎯 Quick Summary

* `git init` → initialize repo
* `git add` → stage changes
* `git commit` → save changes
* `git branch` → manage branches
* `git push` → upload to remote
* `git fetch + merge` → sync with upstream

---
---


# 📘 Git Commands Cheat Sheet (Merge, Rebase, Squash, Stash, Cherry-pick)

---

# 🚀 Git Merge

## 🔹 Basic Merge
```bash
git checkout main
git merge feature
````

## 🔹 Force Merge Commit (even if fast-forward possible)

```bash
git merge --no-ff feature
```

## 🔹 Allow only Fast-Forward

```bash
git merge --ff-only feature
```

---

# ❗ Merge Conflicts

## Check conflict files

```bash
git status
```

## After resolving conflicts

```bash
git add .
git commit
```

## Abort merge

```bash
git merge --abort
```

---

# 🔁 Git Rebase

## Rebase feature branch onto main

```bash
git checkout feature
git rebase main
```

## Continue after resolving conflicts

```bash
git add .
git rebase --continue
```

## Abort rebase

```bash
git rebase --abort
```

## Skip problematic commit

```bash
git rebase --skip
```

---

# 🔀 Squash Merge

## Squash merge a branch

```bash
git checkout main
git merge --squash feature
git commit -m "squashed changes"
```

---

# 📦 Git Stash

## Save changes

```bash
git stash
```

## Save with message

```bash
git stash push -m "work in progress"
```

## List stashes

```bash
git stash list
```

## Apply stash (keep it)

```bash
git stash apply
```

## Apply + delete stash

```bash
git stash pop
```

## Apply specific stash

```bash
git stash apply stash@{0}
```

## Delete stash

```bash
git stash drop stash@{0}
```

## Clear all stashes

```bash
git stash clear
```

---

# 🍒 Git Cherry-Pick

## Pick a specific commit

```bash
git cherry-pick <commit-id>
```

## Cherry-pick multiple commits

```bash
git cherry-pick <commit1> <commit2>
```

## Continue after conflict

```bash
git add .
git cherry-pick --continue
```

## Abort cherry-pick

```bash
git cherry-pick --abort
```

---

# 🔍 Useful Commands

## View commit history

```bash
git log --oneline
```

## Check changes

```bash
git status
```

## View branch list

```bash
git branch
```

## Switch branch

```bash
git checkout <branch>
```

---

# 🎯 Quick Summary

* `git merge` → combine branches safely
* `git rebase` → move commits, clean history
* `git merge --squash` → combine commits into one
* `git stash` → save temporary work
* `git cherry-pick` → copy specific commit





