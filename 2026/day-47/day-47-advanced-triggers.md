Below is the same content you provided, converted into a clean, well‑structured, README‑style document, without changing the meaning or logic. 

 

🚀 GitHub Actions – Workflow Triggers & Automation Examples 

This README documents multiple GitHub Actions workflow patterns, covering pull requests, validations, schedules, smart triggers, workflow chaining, and external event triggers. 

 

✅ Task 1: Pull Request Event Types 

This workflow demonstrates how to respond to different pull request lifecycle events and extract useful metadata. 

Workflow: pr-life-cycle-demo 

Triggers on PR events: 

opened 

synchronize 

reopened 

closed 

Behavior: 

Prints: 

Event type 

PR title 

PR author 

Source branch 

Target branch 

Runs a conditional step only when the PR is merged 

1     name: pr-life-cycle-demo 

2      

3     on: 

4       pull_request: 

5         types: 

6           - opened 

7           - synchronize 

8           - reopened 

9           - closed 

10      

11     jobs: 

12       demo: 

13         runs-on: ubuntu-latest 

14         steps: 

15           - name: Print which event type fired 

16             run: echo "Event Type: ${{ github.event.action }}" 

17      

18           - name: Print the PR title 

19             run: echo "PR title: ${{ github.event.pull_request.title }}" 

20      

21           - name: Print the PR author 

22             run: echo "PR Author: ${{ github.event.pull_request.user.login }}" 

23      

24           - name: Print the source branch and target branch 

25             run: | 

26               echo "Source branch: ${{ github.event.pull_request.head.ref }}" 

27               echo "Target branch: ${{ github.event.pull_request.base.ref }}" 

28      

29           - name: Run only when PR is merged 

30             if: > 

31               github.event.action == 'closed' && 

32               github.event.pull_request.merged == true 

33             run: echo "✅ Pull request was merged successfully!" 

 

✅ Task 2: PR Validation Workflow (PR Gate) 

This workflow enforces quality checks on pull requests targeting main. 

Workflow: PR Checks 

✅ File Size Check 

Fails if any changed file > 1 MB 

✅ Branch Name Check 

Allowed patterns: 

feature/* 

fix/* 

docs/* 

⚠️ PR Body Check 

Warns (does not fail) if PR description is empty 

1     name: PR Checks 

2      

3     on: 

4       pull_request: 

5         branches: 

6           - main 

Jobs Included 

file-size-check 

branch-name-check 

pr-body-check 

(Logic remains exactly as provided in your original workflow.) 

 

✅ Task 3: Scheduled Workflows (Cron Deep Dive) 

Workflow: Scheduled Tasks 

Schedules configured: 

Every Monday at 02:30 AM UTC 

Every 6 hours 

Features: 

Prints which cron schedule triggered the workflow 

Performs a health check using curl 

1     on: 

2       schedule: 

3         - cron: '30 2 * * 1' 

4         - cron: '0 */6 * * *' 

 

Cron Expression Examples 

🕘 Every weekday at 9 AM IST 

Convert IST → UTC: 

9:00 AM IST = 03:30 AM UTC 

✅ Cron 

1     30 3 * * 1-5 

 

📅 First day of every month at midnight (UTC) 

✅ Cron 

1     0 0 1 * * 

 

⚠️ Why Scheduled Workflows May Be Skipped 

GitHub may delay or skip cron jobs on inactive repos (~60 days) 

Helps save compute resources and prevent abuse 

Only scheduled workflows are affected 

Push, PR, and manual runs still work 

Once the repo becomes active again, schedules resume 

 

✅ Task 4: Path & Branch Filters 

Workflow: Smart Triggers (Run Only for App Code) 

Runs only when code changes occur in src/ or app/ on specific branches. 

1     on: 

2       push: 

3         branches: 

4           - main 

5           - 'release/*' 

6         paths: 

7           - 'src/**' 

8           - 'app/**' 

 

Workflow: Skip Docs Changes 

Skips workflow runs if only documentation files change. 

1     on: 

2       push: 

3         branches: 

4           - main 

5           - 'release/*' 

6         paths-ignore: 

7           - '*.md' 

8           - 'docs/**' 

✅ Test result: 
Pushing only a .md file → workflow is skipped. 

 

✅ Task 5: workflow_run — Chain Workflows Together 

Workflow 1: Run Tests 

Runs on every push. 

1     name: Run Tests 

2      

3     on: 

4       push: 

 

Workflow 2: Deploy After Tests 

Runs only after “Run Tests” completes successfully. 

Proceeds if tests ✅ succeeded 

Prints warning and exits if tests ❌ failed 

1     on: 

2       workflow_run: 

3         workflows: ["Run Tests"] 

4         types: [completed] 

 

✅ Task 6: repository_dispatch — External Event Triggers 

Workflow: External Deploy Trigger 

Triggered by an external system (CI tool, Slack bot, monitoring system). 

Responds to event type: deploy-request 

Reads payload data from client_payload 

1     on: 

2       repository_dispatch: 

3         types: 

4           - deploy-request 

Example Payload Data Used 

1     { 

2       "environment": "production" 

3     } 

 

📌 When Would an External System Trigger a Pipeline? 

An external system triggers a pipeline when automation needs to be driven by events outside GitHub, such as: 

A Slack bot approving a deployment 

A monitoring tool triggering rollback after an incident 

A release system promoting code to production 

✅ This enables event‑driven CI/CD, where actions are based on operational signals and approvals rather than code commits. 

 

✅ Summary 

This README demonstrates: 

PR lifecycle events 

PR validation gates 

Cron-based schedules 

Path and branch filtering 

Workflow chaining with workflow_run 

External triggers with repository_dispatch 

These patterns together form a real‑world GitHub Actions automation toolkit. 

 
