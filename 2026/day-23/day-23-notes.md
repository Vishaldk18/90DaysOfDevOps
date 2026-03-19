Task 1: Understanding Branches
Answer these in your day-23-notes.md:

What is a branch in Git?
a branch in git is way to work in collaboration, using which we can have multiple versions of file so that multiple people can work on single file and later they can merge the chnages


Why do we use branches instead of committing everything to main?
we use branches to have for differenet work enviorments like dev,test,prod, if we commited everything to main it can cause conflicts

What is HEAD in Git?
head shows the current status of git repo, with latest commit

What happens to your files when you switch branches?
file have different versions so they remain unchanged acroos branches

What is a branch in Git?
Answer:
A branch in Git is a separate line of development that allows multiple versions of the code to exist. It enables developers to work independently on features, bug fixes, or experiments and later merge their changes into another branch.

Why do we use branches instead of committing everything to main?
Answer:
Branches are used to isolate different types of work such as feature development, bug fixes, and testing. Committing everything directly to the main branch can cause conflicts and instability, whereas branches help keep the main branch stable and production-ready.

What is HEAD in Git?
Answer:
HEAD is a pointer that represents the currently checked-out branch and refers to the latest commit of that branch in the Git repository.

What happens to your files when you switch branches?
Answer:
When you switch branches, Git updates the files in your working directory to match the versions stored in the selected branch. Files may change, appear, or disappear depending on the branch content.

Branching commands

1) git branch : view all local brances -a: local + remote -r: remote only
2) git branch <name> : create new branch
3) git chekout <name> or git switch <name> : switch branch
4) git checkout -b <name> or git switch -c <name> : create and switch branch
5) git branch -d <name> : delete a branch
6) git branch -M main : renames the current branch to main
7) git remote -v :shows the remote repositories linked to your local Git repository along with their URLs for fetching and pushing.
8) git push -u origin main : git push → Uploads local commits to a remote repository, -u (or --set-upstream) → Links the local branch to the remote branch origin → Name of the remote repository, main → Name of the branch being pushed


difference between origin and upstream

Local repo → on your laptop
origin → your fork on GitHub
upstream → the original project on GitHub

Your laptop (local)
   |
   ├── origin    → your GitHub repo
   └── upstream  → original GitHub repo




