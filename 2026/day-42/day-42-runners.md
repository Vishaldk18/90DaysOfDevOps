Task 1: GitHub-Hosted Runners
name: github-hosted-demo
on:
  workflow_dispatch:
jobs:
  ubuntu:
    runs-on: ubuntu-latest
    steps:
      - name: print os info
        run: |
          echo "OS name:$(uname -s)"
          echo "Hostname: $(hostname)"
          echo "Username: $USER"
  windows:
    runs-on: windows-latest
    steps:
      - name: print os info
        shell: powershell
        run: |
          Write-Output "OS name: $env:OS"
          Write-Output "Hostname: $env:COMPUTERNAME"
          Write-Output "Username: $env:USERNAME"
  mac:
    runs-on: macos-latest
    steps:
      - name: print os info
        shell: bash
        run: |
          echo "OS name:$(uname -s)"
          echo "Hostname: $(hostname)"
          echo "Username: $USER"
What is a GitHub-hosted runner? Who manages it?
A GitHub-hosted runner is a temporary virtual machine provided and managed by GitHub to execute workflow jobs. GitHub handles provisioning, maintenance, and scaling, while users only define workflows.

Task 2: Explore What's Pre-installed

name: pre-check
on:
  workflow_dispatch:
jobs:
  check-version:
    runs-on: ubuntu-latest
    steps:
        - name: version_print
          run: |
            docker --version
            git --version
            node --version
            python --version

Why does it matter that runners come with tools pre-installed?
Pre-installed tools reduce setup time, improve consistency, lower CI costs, and simplify workflows. They allow pipelines to start quickly without repeatedly installing dependencies.

Task 3: Set Up a Self-Hosted Runner
Task 4: Use Your Self-Hosted Runner
name: self-hosted-demo

on:
  workflow_dispatch:

jobs:
  self-demo:
    runs-on: self-hosted

    steps:
      - uses: actions/checkout@v4

      - name: print hostname
        run: hostname

      - name: print working directory
        run: |
          echo "PWD: $(pwd)"
          ls -la

      - name: create file
        run: echo "demo file" > demo.txt

      - name: verify file exist
        run: |
          if [ -f demo.txt ]; then
            echo "file exist"
          else
            echo "file does not exist"
          fi

      - name: list files after creation
        run: ls -la

Task 5: Labels

name: self-hosted-demo

on:
  workflow_dispatch:

jobs:
  self-demo:
    runs-on: [self-hosted, Linux, vishals-ec2-instance]

    steps:
      - uses: actions/checkout@v4

      - name: print hostname
        run: hostname

      - name: print working directory
        run: |
          echo "PWD: $(pwd)"
          ls -la

      - name: create file
        run: echo "demo file" > demo.txt

      - name: verify file exist
        run: |
          if [ -f demo.txt ]; then
            echo "file exist"
          else
            echo "file does not exist"
          fi

      - name: list files after creation
        run: ls -la

Why are labels useful when you have multiple self-hosted runners?
Labels are used to route jobs to the correct self-hosted runners based on capabilities, environment, or resources, ensuring efficient, secure, and reliable execution when multiple runners are available.


🧠 What is a Label?

👉 A label is a tag assigned to a self-hosted runner so GitHub knows:

“Which runner should execute this job?”

✅ Default Labels (Already Present)

When you install a self-hosted runner, it automatically gets:

self-hosted
linux / windows / macOS
x64 / arm64
🚀 How to Add Custom Label
🔹 Method 1: During Runner Configuration (Best Way)

When you run:

./config.sh

👉 You’ll see:

Enter labels (optional):

👉 Add labels like:

dev
docker
gpu
🔹 Method 2: Reconfigure Runner

If already installed:

./config.sh remove
./config.sh

👉 Then add labels again

🔹 Method 3: From GitHub UI (Easiest)
Go to your repo
Settings → Actions → Runners
Click your runner
Click ✏️ Edit Labels
Add labels like:
dev
test
prod
🧪 Verify Labels

👉 In GitHub UI, you’ll see something like:

self-hosted, linux, x64, dev
✅ Use Labels in Workflow
Single label:
runs-on: self-hosted
Multiple labels (recommended):
runs-on: [self-hosted, linux, dev]

👉 Means:

Must be self-hosted
Must be Linux
Must have label dev


### Task 6: GitHub-Hosted vs Self-Hosted

| Feature | GitHub-Hosted | Self-Hosted |
|---|---|---|
| Who manages it? | GitHub | User / Organization |
| Cost | Free tier available (pay for extra usage) | Infrastructure cost (VM, maintenance) |
| Pre-installed tools | Available (Python, Docker, Node, etc.) | Must install & manage yourself |
| Setup effort | None | Requires setup & maintenance |
| Good for | Standard CI/CD, quick setup | Custom environments, special requirements |
| Security | Managed & patched by GitHub | User responsible for security |
| Control | Limited | Full control |
| Scalability | Automatic | Manual scaling |
| Persistence | Ephemeral (clean each run) | Persistent (files remain unless cleaned) |


