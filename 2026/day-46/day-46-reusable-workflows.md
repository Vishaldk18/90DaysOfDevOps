## **Task 1: Understand `workflow_call`**

### 1. What is a Reusable Workflow?

A **reusable workflow** is a **complete GitHub Actions workflow** that you can define once and call from other workflows.

It allows you to **share entire job logic** (jobs, steps, conditionals, environments, secrets) across repositories or within the same repository.

Think of it as:

*   ✅ A workflow you can **reuse like a function**
*   ✅ Capable of running **multiple jobs**
*   ✅ Able to accept **inputs and secrets**
*   ✅ Versioned and centralized

✅ **Ideal for:** CI standards, security scans, deployment pipelines, shared build logic

***

### 2. What is the `workflow_call` Trigger?

`workflow_call` is a **special event trigger** that makes a workflow reusable.

It explicitly declares:

*   What **inputs** the workflow accepts
*   What **secrets** can be passed
*   Optional **outputs** it returns

#### Example: Declaring a Reusable Workflow

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

🚫 Without `workflow_call`, a workflow **cannot be called** by another workflow.

***

### 3. Reusable Workflow vs Regular Action

| Aspect                      | Reusable Workflow | Regular Action   |
| --------------------------- | ----------------- | ---------------- |
| Level                       | Workflow / Jobs   | Single step      |
| Can contain jobs            | ✅ Yes             | ❌ No             |
| Triggered by workflow\_call | ✅ Yes             | ❌ No             |
| Reuse scope                 | Full pipelines    | Individual tasks |
| Secrets handling            | Explicit          | Implicit         |
| Use case                    | CI, deployments   | Linting, tooling |

#### Calling a Reusable Workflow

```yaml
jobs:
  build:
    uses: my-org/my-repo/.github/workflows/build.yml@v1
    with:
      node-version: "18"
    secrets:
      NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
```

#### Using a Regular Action

```yaml
steps:
  - uses: actions/setup-node@v4
```

🔑 **Key Rule**

*   `uses:` at **job level** → reusable workflow
*   `uses:` at **step level** → action

***

### 4. Where Must a Reusable Workflow Live?

✅ **Mandatory location**

    .github/workflows/

✅ Valid:

    .github/workflows/deploy.yml
    .github/workflows/ci/build.yml

❌ Invalid:

    .github/actions/build.yml
    .workflows/build.yml

***

## **Task 2: Create Your First Reusable Workflow**

📄 **`.github/workflows/reusable-build.yml`**

```yaml
name: Reusable Build Workflow

on:
  workflow_call:
    inputs:
      app_name:
        description: Application name
        required: true
        type: string
      environment:
        description: Deployment environment
        required: true
        default: staging
        type: string

    secrets:
      docker_token:
        required: true

    outputs:
      build_version:
        description: Generated build version
        value: ${{ jobs.build.outputs.build_version }}

jobs:
  build:
    runs-on: ubuntu-latest

    outputs:
      build_version: ${{ steps.version.outputs.version }}

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Print build info
        run: |
          echo "Building ${{ inputs.app_name }} for ${{ inputs.environment }}"
          echo "Docker token is set: true"

      - name: Generate build version
        id: version
        run: |
          SHORT_SHA=$(echo "${GITHUB_SHA}" | cut -c1-7)
          echo "version=v1.0-${SHORT_SHA}" >> $GITHUB_OUTPUT
```

***

## **Task 3: Create a Caller Workflow**

📄 **`.github/workflows/call-build.yml`**

```yaml
name: Call Reusable Build

on:
  push:
    branches:
      - main

jobs:
  build:
    uses: ./.github/workflows/reusable-build.yml
    with:
      app_name: "my-web-app"
      environment: "production"
    secrets:
      docker_token: ${{ secrets.DOCKER_TOKEN }}
```

✅ Verify in **Actions tab** that the reusable workflow is triggered.

***

## **Task 4: Use Outputs From the Reusable Workflow**

Extend the caller workflow with a second job:

```yaml
jobs:
  build:
    uses: ./.github/workflows/reusable-build.yml
    with:
      app_name: "my-web-app"
      environment: "production"
    secrets:
      docker_token: ${{ secrets.DOCKER_TOKEN }}

  print-version:
    needs: build
    runs-on: ubuntu-latest

    steps:
      - name: Print build version
        run: |
          echo "Build version: ${{ needs.build.outputs.build_version }}"
```

✅ Output flows:

    Step → Job → Workflow → Caller

***

## **Task 5: Create a Composite Action**

### What Is a Composite Action?

A composite action:

*   Groups multiple `run` steps into one action
*   Lives inside `.github/actions/`
*   Is executed using `uses:`
*   Does **not** run on its own
*   Is ideal for shared setup or logic

***

### Composite Action Definition

📄 **`.github/actions/setup-and-greet/action.yml`**

```yaml
name: demo-composite-action
description: action that greets and prints date

inputs:
  name:
    required: true
  language:
    required: true
    default: en

outputs:
  greeted:
    value: ${{ steps.set-output.outputs.greeted }}

runs:
  using: composite
  steps:
    - name: greet
      run: echo "Hello ${{ inputs.name }}"
      shell: bash

    - name: print date and os
      run: |
        echo "Date: $(date)"
        echo "OS: $RUNNER_OS"
      shell: bash

    - name: set output
      id: set-output
      run: echo "greeted=true" >> $GITHUB_OUTPUT
      shell: bash
```

***

### Using the Composite Action

📄 **`.github/workflows/use-composite.yml`**

```yaml
name: Use Composite Action

on:
  push:
    branches:
      - main

jobs:
  greet:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Run setup-and-greet action
        id: greet
        uses: ./.github/actions/setup-and-greet
        with:
          name: Vishal
          language: en

      - name: Verify output
        run: echo "Greeted: ${{ steps.greet.outputs.greeted }}"
```

✅ Verify greeting, date, OS, and output in logs.

***

## **Task 6: Reusable Workflow vs Composite Action**

| Feature                     | Reusable Workflow         | Composite Action       |
| --------------------------- | ------------------------- | ---------------------- |
| Triggered by                | `workflow_call`           | `uses:` in a step      |
| Can contain jobs            | ✅ Yes                     | ❌ No                   |
| Can contain multiple steps  | ✅ Yes                     | ✅ Yes                  |
| Lives where                 | `.github/workflows`       | `.github/actions`      |
| Can accept secrets directly | ✅ Yes                     | ❌ No (indirect only)   |
| Best for                    | Reusable jobs / pipelines | Reusable steps / logic |

***
