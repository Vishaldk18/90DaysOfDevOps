## ✅ Task 1: Pull Request Event Types

This workflow demonstrates how to respond to different **pull request lifecycle events** and extract useful metadata.

### Workflow: `pr-life-cycle-demo`

**Triggers on PR events:**

*   `opened`
*   `synchronize`
*   `reopened`
*   `closed`

**Behavior:**

*   Prints:
    *   Event type
    *   PR title
    *   PR author
    *   Source branch
    *   Target branch
*   Runs a conditional step **only when the PR is merged**

```yaml
name: pr-life-cycle-demo

on:
  pull_request:
    types:
      - opened
      - synchronize
      - reopened
      - closed

jobs:
  demo:
    runs-on: ubuntu-latest
    steps:
      - name: Print which event type fired
        run: echo "Event Type: ${{ github.event.action }}"

      - name: Print the PR title
        run: echo "PR title: ${{ github.event.pull_request.title }}"

      - name: Print the PR author
        run: echo "PR Author: ${{ github.event.pull_request.user.login }}"

      - name: Print the source branch and target branch
        run: |
          echo "Source branch: ${{ github.event.pull_request.head.ref }}"
          echo "Target branch: ${{ github.event.pull_request.base.ref }}"

      - name: Run only when PR is merged
        if: >
          github.event.action == 'closed' &&
          github.event.pull_request.merged == true
        run: echo "✅ Pull request was merged successfully!"
```

***

## ✅ Task 2: PR Validation Workflow (PR Gate)

This workflow enforces **quality checks** on pull requests targeting `main`.

### Workflow: `PR Checks`

#### ✅ File Size Check

*   Fails if **any changed file > 1 MB**

#### ✅ Branch Name Check

Allowed patterns:

*   `feature/*`
*   `fix/*`
*   `docs/*`

#### ⚠️ PR Body Check

*   Warns (does **not fail**) if PR description is empty

```yaml
name: PR Checks

on:
  pull_request:
    branches:
      - main
```

### Jobs Included

*   `file-size-check`
*   `branch-name-check`
*   `pr-body-check`

(Logic remains exactly as provided in your original workflow.)

***

## ✅ Task 3: Scheduled Workflows (Cron Deep Dive)

### Workflow: `Scheduled Tasks`

**Schedules configured:**

*   Every Monday at **02:30 AM UTC**
*   Every **6 hours**

**Features:**

*   Prints which cron schedule triggered the workflow
*   Performs a **health check using curl**

```yaml
on:
  schedule:
    - cron: '30 2 * * 1'
    - cron: '0 */6 * * *'
```

***

### Cron Expression Examples

#### 🕘 Every weekday at 9 AM IST

Convert IST → UTC:

*   9:00 AM IST = **03:30 AM UTC**

✅ **Cron**

    30 3 * * 1-5

***

#### 📅 First day of every month at midnight (UTC)

✅ **Cron**

    0 0 1 * *

***

### ⚠️ Why Scheduled Workflows May Be Skipped

*   GitHub may delay or skip cron jobs on **inactive repos (\~60 days)**
*   Helps save compute resources and prevent abuse
*   **Only scheduled workflows are affected**
*   Push, PR, and manual runs still work
*   Once the repo becomes active again, schedules resume

***

## ✅ Task 4: Path & Branch Filters

### Workflow: Smart Triggers (Run Only for App Code)

Runs **only when code changes** occur in `src/` or `app/` on specific branches.

```yaml
on:
  push:
    branches:
      - main
      - 'release/*'
    paths:
      - 'src/**'
      - 'app/**'
```

***

### Workflow: Skip Docs Changes

Skips workflow runs if **only documentation files change**.

```yaml
on:
  push:
    branches:
      - main
      - 'release/*'
    paths-ignore:
      - '*.md'
      - 'docs/**'
```

✅ **Test result:**  
Pushing only a `.md` file → workflow is skipped.

***

## ✅ Task 5: `workflow_run` — Chain Workflows Together

### Workflow 1: Run Tests

Runs on every push.

```yaml
name: Run Tests

on:
  push:
```

***

### Workflow 2: Deploy After Tests

Runs **only after “Run Tests” completes successfully**.

*   Proceeds if tests ✅ succeeded
*   Prints warning and exits if tests ❌ failed

```yaml
on:
  workflow_run:
    workflows: ["Run Tests"]
    types: [completed]
```

***

## ✅ Task 6: `repository_dispatch` — External Event Triggers

### Workflow: External Deploy Trigger

Triggered by an **external system** (CI tool, Slack bot, monitoring system).

*   Responds to event type: `deploy-request`
*   Reads payload data from `client_payload`

```yaml
on:
  repository_dispatch:
    types:
      - deploy-request
```

### Example Payload Data Used

```json
{
  "environment": "production"
}
```

***

### 📌 When Would an External System Trigger a Pipeline?

An external system triggers a pipeline when automation needs to be driven by **events outside GitHub**, such as:

*   A Slack bot approving a deployment
*   A monitoring tool triggering rollback after an incident
*   A release system promoting code to production

✅ This enables **event‑driven CI/CD**, where actions are based on operational signals and approvals rather than code commits.

***

## ✅ Summary

This README demonstrates:

*   PR lifecycle events
*   PR validation gates
*   Cron-based schedules
*   Path and branch filtering
*   Workflow chaining with `workflow_run`
*   External triggers with `repository_dispatch`

These patterns together form a **real‑world GitHub Actions automation toolkit**.
