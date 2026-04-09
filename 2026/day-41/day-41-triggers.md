## 🔹 Task 1: Trigger on Pull Request

```yaml
name: trigger-demo

on:
  pull_request:
    branches: [main]
    types: [opened, synchronize]

jobs:
  pr-check:
    runs-on: ubuntu-latest
    steps:
      - name: PR check running for branch
        run: echo "${{ github.ref_name }}"
````

---

## 🔹 Task 2: Scheduled Trigger

```yaml
name: schedule-trigger

on:
  schedule:
    - cron: '24 19 * * *'

jobs:
  schedule-job:
    runs-on: ubuntu-latest
    steps:
      - name: print date
        run: date
```

---

## 🔹 Task 3: Manual Trigger

```yaml
name: manual-trigger

on:
  workflow_dispatch:
    inputs:
      environment:
        description: choose the environment in which to trigger workflow
        required: true
        default: staging
        type: choice
        options:
          - staging
          - production

jobs:
  input-name:
    runs-on: ubuntu-latest
    steps:
      - name: print input name
        run: echo "${{ inputs.environment }}"
```

---

## 🔹 Task 4: Matrix Builds

```yaml
name: matrix-demo

on:
  workflow_dispatch:

jobs:
  python-setup:
    runs-on: ${{ matrix.os }}

    strategy:
      matrix:
        os: ["ubuntu-latest", "windows-latest"]
        python-version: ["3.10", "3.11", "3.12"]

    steps:
      - name: setup python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: verify version
        run: python --version
```

---

## 🔹 Task 5: Exclude & Fail-Fast

```yaml
name: matrix-demo

on:
  workflow_dispatch:

jobs:
  python-setup:
    runs-on: ${{ matrix.os }}

    strategy:
      fail-fast: false
      matrix:
        os: ["ubuntu-latest", "windows-latest"]
        python-version: ["3.10", "3.11", "3.12"]

        exclude:
          - os: windows-latest
            python-version: "3.10"

    steps:
      - name: setup python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: verify version
        run: python --version
```

---

## 🧠 Key Concept: Fail-Fast

> By default, fail-fast is **true**, meaning if any matrix job fails, the remaining jobs are cancelled.
> Setting it to **false** ensures all jobs run to completion, which is useful for full test coverage.
