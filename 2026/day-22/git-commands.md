
# Git commands

setup & config commands

1) git config --global --list : command to see global config, for which user it is set currently

2) git config --global user.name "<your username>" - command to set username

3) git config --global user.email "<your email>" - command to set email


Basic Workflow 

1) first create a folder
2) initialize the folder so that you can track using git use command git init
3) create a sample file to track it
4) to track the file use command git add sample_file, now the file is in staging area but still not trackable
5) to track file use git commit -m "message",now the file is tracked 

this is how a simple git workflow works

Viewing changes

1) git status - you can use this command to check the status like file is tracked or not
2) git log - to see logs, commit hash

Branching commands

1) git branch : view all local brances -a: local + remote -r: remote only
2) git branch <name> : create new branch
3) git chekout <name> or git switch <name> : switch branch
4) git checkout -b <name> or git switch -c <name> : create and switch branch
5) git branch -d <name> : delete a branch


