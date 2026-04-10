# 🚀 GitHub Actions Tasks

---

## 🔹 Task 1: GitHub Secrets

```yaml
name: secret-demo

on:
  workflow_dispatch:

jobs:
  demo:
    runs-on: ubuntu-latest
    steps:
      - name: try to print secret
        run: |
          echo "The secret is set: true"
          echo "Secret Value: ${{ secrets.MY_SECRET_MESSAGE }}"
````

Secrets should never be printed in CI logs because logs are accessible and persistent, making it easy for attackers to extract credentials and compromise systems.

---

## 🔹 Task 2: Use Secrets as Environment Variables

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

## 🔹 Task 3: Upload Artifacts

```yaml
name: upload-artifact-demo

on:
  workflow_dispatch:

jobs:
  generate-artifact:
    runs-on: ubuntu-latest

    steps:
      - name: generate report
        run: |
          echo "Log-Report-$(date)" > log.txt
          echo "Log Generated Successfully." >> log.txt

      - name: verify generation
        run: ls -la

      - name: upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: test-report
          path: log.txt
```

---

## 🔹 Task 4: Download Artifacts Between Jobs

```yaml
name: use-artifact-demo

on:
  workflow_dispatch:

jobs:
  generate-artifact:
    runs-on: ubuntu-latest

    steps:
      - name: generate log report
        run: |
          echo "log-report-$(date)" > new_log.txt
          echo "log generated successfully" >> new_log.txt

      - name: verify file
        run: ls -la

      - name: upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: new-log-report
          path: new_log.txt

  use-artifact:
    runs-on: ubuntu-latest

    steps:
      - name: download artifact
        uses: actions/download-artifact@v4
        with:
          name: new-log-report

      - name: show report content
        run: |
          echo "file content:"
          cat new_log.txt
```

---

## 🔹 Task 5: Run Real Tests in CI

```bash
# script.sh
#!/bin/bash

echo "Running script..."

# Change this to simulate failure
exit 0
#exit 1
```

```yaml
name: script-demo

on:
  workflow_dispatch:

jobs:
  script-demo-job:
    runs-on: ubuntu-latest

    steps:
      - name: checkout code
        uses: actions/checkout@v4

      - name: list files
        run: ls -la

      - name: make script executable
        run: chmod +x script.sh

      - name: execute the script
        run: |
          ./script.sh
```

---

## 🔹 Task 6: Caching

```yaml
name: cache-demo

on:
  workflow_dispatch:

jobs:
  cache-job:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.11"

      - name: Cache pip dependencies
        uses: actions/cache@v4
        with:
          path: ~/.cache/pip
          key: ${{ runner.os }}-pip-${{ hashFiles('requirements.txt') }}
          restore-keys: |
            ${{ runner.os }}-pip-

      - name: Install dependencies
        run: pip install -r requirements.txt
```

---

## 🧠 Interview Question

### ❓ What is being cached and where is it stored?

👉 In GitHub Actions, caching typically stores dependency files such as pip packages, npm modules, or build dependencies to avoid re-downloading them on every run. These cached files are stored in GitHub’s remote cache storage, not on the runner, and are restored in subsequent workflow runs using a cache key.

---
