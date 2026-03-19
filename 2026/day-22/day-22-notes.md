Below are **clean, correct, copy‑paste–ready answers**.  
You can **copy them directly** for notes, exams, or interviews.

***

## 1. What is the difference between `git add` and `git commit`?

**Answer:**  
`git add` moves changes from the working directory to the staging area and starts tracking files.  
`git commit` saves the staged changes permanently to the Git repository as a snapshot with a commit message.

***

## 2. What does the staging area do? Why doesn’t Git commit directly?

**Answer:**  
The staging area allows developers to select and review specific changes before committing.  
Git does not commit directly so that changes can be grouped logically, reviewed, and committed in a clean and controlled way.

***

## 3. What information does `git log` show you?

**Answer:**  
`git log` shows the commit history including commit hash, author name and email, date and time of the commit, commit message, and the order of commits (latest first).

***

## 4. What is the `.git/` folder and what happens if you delete it?

**Answer:**  
The `.git/` folder contains all Git metadata such as commit history, branches, configuration, and HEAD pointer.  
If the `.git/` folder is deleted, the project loses all version control history and becomes a normal folder, though the files themselves remain.

***

## 5. What is the difference between a working directory, staging area, and repository?

**Answer:**

*   **Working Directory:** Where files are created and modified.
*   **Staging Area:** Where selected changes are prepared for the next commit.
*   **Repository:** Where committed changes are permanently stored as snapshots.

***

### ✅ One‑line Flow (easy to remember)

    Working Directory → git add → Staging Area → git commit → Repository

