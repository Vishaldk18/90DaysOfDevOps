## 🔹 Task 1: Multi-Job Workflow

```yaml
name: multi-job

on:
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: print bulding the app
        run: echo "building the app"

  test:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: print testing
        run: echo "testing the app"

  deploy:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - name: print deploy
        run: echo "deployinng the app"
````

---

## 🔹 Task 2: Environment Variables

```yaml
name: env-check

on:
  workflow_dispatch:

# workflow level environment variable
env:
  APP_NAME: myapp

jobs:
  demo-job:
    runs-on: ubuntu-latest

    # job level env variable
    env:
      ENVIRONMENT: staging

    steps:
      - name: print all env varibales and github context

        # step level env
        env:
          VERSION: 1.0.0

        run: |
          echo "App Name: $APP_NAME"
          echo "Environment: $ENVIRONMENT"
          echo "Version: $VERSION"
          echo "Github commit SHA: ${{ github.sha }}"
          echo "Github Actor: ${{ github.actor }}"
```

---

## 🔹 Task 3: Job Outputs

```yaml
name: output-example

on:
  workflow_dispatch:

jobs:
  generate-date:
    runs-on: ubuntu-latest

    outputs:
      today: ${{ steps.set-date.outputs.today }}

    steps:
      - name: set todays date
        id: set-date
        run: |
          echo "today=$(date +'%Y-%m-%d')" >> $GITHUB_OUTPUT

  use-date:
    needs: generate-date
    runs-on: ubuntu-latest

    steps:
      - name: print date from previous job output
        run: echo "Todays date is ${{ needs.generate-date.outputs.today }}"
```

---

## 🔹 Task 4: Conditionals

```yaml
name: conditionals

on:
  push:
  workflow_dispatch:

jobs:
  demo_job:
    runs-on: ubuntu-latest

    steps:
      - name: A step that only runs when the branch is main
        if: ${{ github.ref_name == 'main' }}
        run: echo "running on main branch"

      # - name: demo fail step
      #   run: exit 1

      - name: A step that only runs when the previous step failed
        if: ${{ failure() }}
        run: echo "previous step failed"

      - name: Step with continue-on-error
        continue-on-error: true
        run: |
          echo "This step will fail but workflow continues"
          exit 1

      - name: This still runs despite failure above
        run: echo "Workflow did not stop 👍"

  push-event-job:
    runs-on: ubuntu-latest
    if: ${{ github.event_name == 'push'}}

    steps:
      - name: A job that only runs on push events, not on pull requests
        run: echo "job is running as push event happened"
```

---

## 🔹 Task 5: Smart Workflow

```yaml
name: smart-workflow

on:
  push:

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - name: lint step
        run: echo "linting the code"

  test:
    runs-on: ubuntu-latest
    steps:
      - name: test step
        run: echo "testing the code"

  summary:
    runs-on: ubuntu-latest
    needs: [lint, test]

    steps:
      - name: Print branch type
        run: |
          if [ "${{ github.ref_name }}" = "main" ]; then
            echo "this is main branch"
          else
            echo "this is feature branch"
          fi

      - name: Print commit message
        run: |
          echo "Commit message: ${{ github.event.head_commit.message }}"
