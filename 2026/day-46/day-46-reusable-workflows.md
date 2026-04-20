Task 1: Understand workflow_call
## 1. What is a reusable workflow?

A **reusable workflow** is a **complete GitHub Actions workflow** that you can define once and call from other workflows.  
Its purpose is to **share entire job logic** (jobs, steps, conditionals, environments, secrets) across repositories or within the same repository.

Think of it as:

*   ✅ A workflow you can **reuse like a function**
*   ✅ Capable of running **multiple jobs**
*   ✅ Able to accept **inputs and secrets**
*   ✅ Versioned and centralized

✅ Ideal for: CI standards, security scans, deployment pipelines, shared build logic.

***

## 2. What is the `workflow_call` trigger?

`workflow_call` is a **special event trigger** that makes a workflow reusable.

It explicitly declares:

*   What **inputs** the workflow accepts
*   What **secrets** can be passed to it
*   Optional **outputs** it returns

### Example: Declaring a reusable workflow

```yaml
# .github/workflows/build.yml
name: Reusable Build

on:
  workflow_call:
    inputs:
      node-version:
        required: true
        type: string
    secrets:
      NPM_TOKEN:
        required: true
```

Without `workflow_call`, a workflow **cannot be called by another workflow**.

***

## 3. How is calling a reusable workflow different from using a regular action (`uses:`)?

| Aspect                       | Reusable Workflow         | Regular Action             |
| ---------------------------- | ------------------------- | -------------------------- |
| Level                        | **Workflow / Jobs**       | **Single step**            |
| Can contain jobs             | ✅ Yes                     | ❌ No                       |
| Triggered by `workflow_call` | ✅ Yes                     | ❌ No                       |
| Reuse scope                  | Full pipelines            | Individual tasks           |
| Secrets handling             | Explicitly defined        | Implicit / inherited       |
| Use case                     | CI pipelines, deployments | Linting, checkout, tooling |

### Calling a reusable workflow

```yaml
jobs:
  build:
    uses: my-org/my-repo/.github/workflows/build.yml@v1
    with:
      node-version: "18"
    secrets:
      NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
```

### Using a regular action

```yaml
steps:
  - uses: actions/setup-node@v4
```

🔑 **Key difference**

*   `uses:` at **job level** → reusable workflow
*   `uses:` at **step level** → action

***

## 4. Where must a reusable workflow file live?

✅ **Mandatory location:**

    .github/workflows/

❌ It **cannot** be placed anywhere else.

### Valid paths

```text
.github/workflows/deploy.yml
.github/workflows/ci/build.yml
```

### Invalid paths

```text
.github/actions/build.yml     ❌
.workflows/build.yml          ❌
```

GitHub **only recognizes reusable workflows** from `.github/workflows/`.

***

## Summary

*   ✅ A reusable workflow is a **callable workflow**, not just a step
*   ✅ `workflow_call` enables workflows to be reused
*   ✅ Reusable workflows operate at the **job/pipeline level**
*   ✅ Regular actions operate at the **step level**
*   ✅ Reusable workflow files **must** live in `.github/workflows/`


Task 2: Create Your First Reusable Workflow
name: reusable-workflow
on:
 workflow_call:
  inputs:
    app_name:
     type: string
     required: true
    environment:
     type: string
     required: true
     default: staging
  secrets:
    docker_token:
     required: true
   
jobs:
 code:
  runs-on: ubuntu-latest
  steps:
    - name: checkout code
      uses: actions/checkoutcode@v4
 print:
  runs-on: ubuntu-latest
  steps:
    - name: print app name with enviornment
      run: echo "Building ${{ inputs.app_name }} for ${{ inputs.environment }}"
 print2:
  runs-on: ubuntu-latest
  steps:
    - name: print secret set
      run: echo "Docker token is set':' true"


Task 3: Create a Caller Workflow
 name: call-another-workflow
on:
 push:
  branches: [main]
jobs:
  build:
   uses: ./.github/workflows/reusable-build.yml
   with:
    app_name: "my-web-app"
    environment: "production"
   secrets:
    docker_token: ${{ secrets.DOCKERHUB_PASSWORD }}


