# 🚀 Git Merge

## 🟢 1. Fast-Forward Merge

### 👉 What it means:
A fast-forward merge happens when there is **no divergence** between branches.

### 👉 In simple terms:
- Your target branch (e.g., `main`) has **not moved forward**
- Git can just **move the pointer forward**

### 📊 Example:
```

main:    A---B
feature:      C---D

```

### ✅ After merge:
```

main:    A---B---C---D

````

### ✔ Key Points:
- No extra commit is created  
- History is **linear and clean**

### 💡 Command:
```bash
git merge feature
````

> If possible, Git performs fast-forward merge by default.

---

## 🔴 2. Merge Commit (3-Way Merge)

### 👉 What it means:

A merge commit happens when **both branches have progressed independently**.

### 👉 In simple terms:

* Both `main` and `feature` have **new commits**
* Git needs to **combine histories**

### 📊 Example:

```
main:    A---B---E
feature:      C---D
```

### ✅ After merge:

```
main:    A---B---E
              \   \
               C---D
                    \
                     M   ← merge commit
```

### ✔ Key Points:

* A new commit (`M`) is created
* History becomes **non-linear**

---

## ⚔️ Difference Summary

| Feature            | Fast-Forward Merge | Merge Commit         |
| ------------------ | ------------------ | -------------------- |
| New Commit Created | ❌ No               | ✅ Yes                |
| History Type       | Linear             | Non-linear           |
| Use Case           | Simple changes     | Parallel development |

---

## 🎯 One-Line Explanation

* **Fast-forward merge:** moves pointer forward (no commit)
* **Merge commit:** creates a new commit to combine histories

---

## ❓ Important Questions

### ✅ What is a Fast-Forward Merge?

A fast-forward merge happens when the target branch has no new commits, so Git simply moves the branch pointer forward to include the new commits.

👉 In short: No new commit is created, history stays linear.

---

### ✅ When does Git create a Merge Commit instead?

Git creates a merge commit when both branches have new commits (they diverged) and cannot be fast-forwarded.

👉 In short: Git creates a new commit to combine both histories.

---

### ✅ What is a Merge Conflict?

A merge conflict happens when Git cannot automatically merge changes, usually because the same file/line was modified in both branches.

👉 In short: Git needs manual input to decide which change to keep.

---

# 🔁 Git Rebase

### ✅ What is Git Rebase?

Git rebase means taking your commits and placing them on top of another branch.

👉 In simple words:
“Rebase moves your work to the latest version of the branch.”

---

### 🎯 One-line answer:

👉 Git rebase re-applies your commits on top of another branch to keep history clean and linear.

---

## 📊 Scenario

You are working on a feature branch, and main has new updates.

### 📊 Before Rebase

```
main:    A---B---C
feature:      D---E
```

👉 Your branch is behind main

---

### 💡 Run Rebase

```bash
git checkout feature
git rebase main
```

---

### 📊 After Rebase

```
main:    A---B---C
feature:          D'---E'
```

👉 Your commits (D, E) are moved on top of latest main (C)
👉 History becomes straight line

---

### 🧠 Simple Understanding

* Before: Your work is based on old code
* After: Your work is based on latest code

---

### 🎯 One-line (with example)

👉 “Git rebase moves my feature branch commits on top of latest main, so history stays clean and updated.”

---

## ❗ Should we rebase main?

👉 Short answer:
Yes — you should NOT rebase main (or any shared branch).

---

### ❌ Why not?

Because rebase rewrites history.

👉 When you rebase:

* Old commits are replaced with new commit IDs
* History changes

---

### ⚠️ Problem in real teams

If others are using main and you rebase it:

* Their local history ≠ your rewritten history
* They will face:

  * conflicts
  * duplicate commits
  * broken pulls

👉 Basically: you mess up the team’s history

---

### 🧠 Simple Example

Before:

```
main: A---B---C
```

After rebase:

```
main: A---B---C'
```

👉 Now others still have C, but repo has C' → mismatch 😬

---

### ✅ Rule to remember

* ✔ Rebase → only your local/feature branch
* ❌ Never rebase → shared branches (main, develop)

---

### 🎯 Interview One-liner

👉 “We don’t rebase main because rebase rewrites history, which can break collaboration for other developers.”

---

## ✅ Can we merge shared branches?

👉 Yes — merging shared branches is safe and recommended.

---

### 🧠 Why merge is safe?

Because merge does NOT rewrite history.

👉 It:

* Keeps all existing commits unchanged
* Just adds a new merge commit
* Preserves full history

---

### 📊 Example

```
main:    A---B---C
feature:      D---E
```

After merge:

```
main:    A---B---C
              \   \
               D---E
                    \
                     M
```

👉 No commits are changed
👉 Just a new commit M is added

---

### 🔥 Key Difference

* Merge: Safe for shared branches ✅
* Rebase: Unsafe for shared branches ❌

---

### 🎯 Interview One-liner

👉 “Yes, we can merge shared branches because merge preserves history and doesn’t rewrite commits, making it safe for collaboration.”

---

## ❓ Rebase Deep Questions

### ✅ What does rebase actually do to your commits?

Rebase takes your commits and replays them on top of another branch.

👉 It creates new commits (new IDs) with the same changes.

---

### ✅ How is the history different from a merge?

* Rebase: linear history
* Merge: branch history preserved

---

### ✅ Why should you never rebase shared commits?

Because rebase changes commit history (IDs), causing conflicts and confusion for others.

---

### ✅ When would you use rebase vs merge?

👉 Use Rebase when:

* Working on your local feature branch
* Want clean, linear history

👉 Use Merge when:

* Working with team/shared branches
* Want to preserve history safely

---

### 🎯 Super Short Version

* Rebase → rewrites commits
* Merge → preserves commits
* Never rebase shared commits

---

# 🔀 Squash Merge

### ✅ What does squash merging do?

Squash merge combines all commits from a branch into a single commit before merging.

👉 “Multiple commits become one clean commit.”

---

### 📊 Example

Before:

```
feature: A---B---C
```

After:

```
main: ---D   (A+B+C combined)
```

---

### ✅ When to use squash merge?

👉 Use when:

* Many small commits
* Want clean history

👉 Use regular merge when:

* You want full commit history

---

### ⚠️ Trade-off

* Lose detailed commit history
* Harder debugging

---

### 🎯 One-liners

* Squash → one commit
* Trade-off → lose history

---

## ❗ Important

👉 After `git merge --squash`, you must run commit manually

```bash
git checkout master
git merge --squash feature-branch
git commit -m "combined changes from feature-branch"
```

---

### 🔥 Difference

| Command            | Auto Commit |
| ------------------ | ----------- |
| git merge          | ✅ Yes       |
| git merge --squash | ❌ No        |

---

### 🎯 One-line

👉 “Squash merge stages changes but requires manual commit.”

---

# 📦 Git Stash

### ✅ Difference between stash apply and pop

* `git stash apply` → apply + keep stash
* `git stash pop` → apply + delete stash

---

### 🎯 One-line

👉 apply = keep
👉 pop = delete

---

### ✅ Real-world use cases

#### 1. Switch branches quickly

```bash
git stash
git checkout main
```

#### 2. Pull safely

```bash
git stash
git pull
git stash pop
```

#### 3. Save incomplete work

* Avoid messy commits

---

### 🎯 One-line

👉 “Stash saves temporary work without committing.”

---

# 🍒 Git Cherry-Pick

### ✅ What does cherry-pick do?

Copies a specific commit from one branch to another.

---

### 📊 Example

```
feature: A---B---C
main:    A---D
```

After:

```
main:    A---D---C'
```

---

### ✅ Use cases

* Hotfix
* Selective changes
* Backporting

---

### ⚠️ Risks

* Duplicate commits
* Merge conflicts
* Missing dependencies

---

### 🎯 One-line

👉 Cherry-pick → copy one commit
👉 Risk → conflicts & duplicates

---



