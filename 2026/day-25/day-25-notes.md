# ✅ Difference between `--soft`, `--mixed`, `--hard`

👉 All three move **HEAD to an older commit**, but differ in what they keep/remove:

| Option    | Commit History | Staging Area | Working Directory |
| --------- | -------------- | ------------ | ----------------- |
| `--soft`  | Reset          | ✅ Keep       | ✅ Keep            |
| `--mixed` | Reset          | ❌ Clear      | ✅ Keep            |
| `--hard`  | Reset          | ❌ Clear      | ❌ Delete          |

---

### 🧠 Simple Understanding

* **--soft** → undo commit, keep everything staged
* **--mixed** → undo commit, unstage changes
* **--hard** → delete everything (commit + changes)

---

# ⚠️ Which one is destructive and why?

👉 **`--hard` is destructive**

### ❌ Why?

* It deletes:

  * commits
  * staged changes
  * working directory changes

👉 Data is **lost permanently** (unless recovered via reflog)

---

# ✅ When would you use each?

### 🟢 `--soft`

👉 When you want to:

* Fix last commit
* Combine commits

---

### 🟡 `--mixed` (default)

👉 When you want to:

* Unstage files
* Rework changes before committing again

---

### 🔴 `--hard`

👉 When you want to:

* Completely discard changes
* Reset project to a clean state

---

# 🚫 Should you use reset on pushed commits?

👉 **No (generally avoid it)**

### ❌ Why?

* Reset rewrites history
* Other developers will have different history
* Causes conflicts and confusion

---

### ✅ When is it okay?

* Only on **local commits (not pushed)**
* Or if you **force push knowingly** (advanced use)

---

# 🎯 Interview One-liners

* “Soft keeps staging, mixed unstages, hard deletes everything.”
* “Hard reset is destructive because it removes working directory changes.”
* “Reset should not be used on shared commits because it rewrites history.”

---

---

# Git Revert Syntax
git revert <commit-id>
🧠 What it does

👉 Creates a new commit that undoes changes from the specified commit
👉 Does NOT delete history (safe for shared branches)

---


---

# ✅ Difference between `git revert` and `git reset`

### 🔹 `git reset`

* Moves **HEAD backward**
* Can **remove commits**
* Can change history ❌

👉 Example:

```bash
git reset --hard HEAD~1
```

👉 Last commit is **deleted**

---

### 🔹 `git revert`

* Creates a **new commit**
* Undoes changes of a previous commit
* Keeps history intact ✅

👉 Example:

```bash
git revert HEAD
```

👉 Adds a new commit that cancels previous one

---

### 🎯 Simple Difference

* **Reset → delete/rewind history**
* **Revert → undo via new commit**

---

# 🛡️ Why is revert safer for shared branches?

👉 Because it **does NOT rewrite history**

### 🧠 Why this matters:

* Other developers already have the commits
* Rewriting history (reset) causes:

  * conflicts
  * broken pulls
  * mismatch

👉 Revert avoids all this by **adding a new commit instead**

---

# ✅ When to use revert vs reset?

### 🟢 Use `git revert` when:

* Working on **shared branches (main, develop)**
* Want to safely undo a change
* Working in a team

---

### 🟡 Use `git reset` when:

* Working on **local commits (not pushed)**
* Fixing mistakes before sharing
* Cleaning commit history

---

# ⚠️ Important Rule

👉 ❌ Never use `git reset` on pushed/shared commits
👉 ✅ Use `git revert` instead

---

# 🎯 Interview One-liners

* “Reset rewrites history, revert preserves history.”
* “Revert is safer because it creates a new commit instead of deleting commits.”
* “Use reset locally, revert in shared branches.”

---

# 🔄 git reset vs git revert

| Feature | git reset | git revert |
|--------|----------|------------|
| **What it does** | Moves HEAD to previous commit and can remove commits | Creates a new commit that undoes a previous commit |
| **Removes commit from history?** | ✅ Yes (history is rewritten) | ❌ No (history is preserved) |
| **Safe for shared/pushed branches?** | ❌ No | ✅ Yes |
| **When to use** | Local changes, fix commits before pushing, cleanup history | Undo changes safely in shared branches (main/develop) |

---

## 🎯 Quick Summary

- **git reset** → rewrite history (use locally)  
- **git revert** → safe undo using new commit (use in team)  

---



# 🌿 Branching Strategies (Short Notes)

---

## 🚀 GitFlow

### 🧠 How it works
- `main`, `develop`, `feature`, `release`, `hotfix` branches  

### 📊 Flow
main ← release ← develop ← feature  

### 📌 Use
- Large teams, scheduled releases  

### ✅ Pros
- Structured  
- Good release control  

### ❌ Cons
- Complex  
- Slow  

---

## 🌊 GitHub Flow

### 🧠 How it works
- Single `main` + feature branches + PR  

### 📊 Flow
main ← feature → PR → merge  

### 📌 Use
- Fast-moving apps, CI/CD  

### ✅ Pros
- Simple  
- Fast  

### ❌ Cons
- Less control over releases  

---

## 🌳 Trunk-Based Development

### 🧠 How it works
- Everyone commits to `main`  
- Short-lived branches  

### 📊 Flow
main ← small frequent commits  

### 📌 Use
- High-speed DevOps teams  

### ✅ Pros
- Very fast  
- Fewer conflicts  

### ❌ Cons
- Needs strong testing  

---

# 🎯 Answers

👉 Startup shipping fast → **GitHub Flow / Trunk-Based**  

👉 Large team with releases → **GitFlow**  

👉 Open-source → **GitHub Flow (mostly)**  

---

