# 🚀 Task 1: Set Up

* Create a new public GitHub repository called **`github-actions-practice`**
* Clone it locally
* Create the folder structure:

```bash
.github/workflows/
```

---

# 👋 Task 2: Hello Workflow

### 📄 `hello.yml`

```yaml
name: hello

on:
  push:
    branches: [main]

jobs:
  greet:
    runs-on: ubuntu-latest

    steps:
      - name: chekout code
        uses: actions/checkout@v4

      - name: print statement
        run: echo "Hello from GitHub Actions!"
```

---

# 🧠 Task 3: Understand the Anatomy

Look at your workflow file and write in your notes what each key does:

* **`on`** keyword defines when the workflow is triggered
* **`jobs`** section contains all the jobs that need to be executed
* Each job runs on a specified runner using **`runs-on`**
* Inside each job, **`steps`** define individual tasks
* **`uses`** keyword is used to call pre-built GitHub Actions
* **`run`** executes custom shell commands
* **`name`** field is used to label workflows, jobs, or steps for better readability

---

# ⚙️ Task 4: Add More Steps

```yaml
name: hello

on:
  push:
    branches: [main]

jobs:
  greet:
    runs-on: ubuntu-latest

    steps:
      - name: chekout code
        uses: actions/checkout@v4

      - name: print statement
        run: echo "Hello from GitHub Actions!"

      - name: Print the current date and time
        run: date

      - name: Print the name of the branch that triggered the run
        run: echo ${{ github.ref_name }}

      - name: List the files in the repo
        run: ls -la

      - name: Print the runner's operating system
        run: uname -s
```
