What authentication methods does gh support?
https and ssh (using token or web login)

How could you use gh issue in a script or automation?
I use gh issue in scripts to automate incident tracking. For example, if a deployment or monitoring check fails, a script can automatically create or update a GitHub issue with logs, labels, and assignees. This integrates GitHub with CI/CD and monitoring systems.


What merge methods does gh pr merge support?
gh pr merge supports merge commit, squash, and rebase strategies. Choice depends on whether we want full history, clean history, or linear commit structure.

How would you review someone else's PR using gh?
To review a PR using GitHub CLI, I list PRs, inspect details with gh pr view, check out the branch locally, review changes using gh pr diff, and then approve or request changes using gh pr review. This allows full review without using the UI.

How could gh run and gh workflow be useful in a CI/CD pipeline?
gh run and gh workflow are useful in CI/CD pipelines because they allow triggering, monitoring, and debugging workflows directly from the command line. This enables automation through scripts, integration with other tools, and faster incident handling without relying on the GitHub UI.”
