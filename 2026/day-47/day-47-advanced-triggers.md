Task 1: Pull Request Event Types

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
      run: |
          echo "Event Type: ${{ github.event.action }}"
    - name: Print the PR title
      run: |
          echo "PR title: ${{ github.event.pull_request.title }}"
    - name: Print the PR author
      run: |
          echo "PR Author: ${{ github.event.pull_request.user.login }}"
    - name: Print the source branch and target branch
      run: |
         echo "Source branch: ${{ github.event.pull_request.head.ref }}"
         echo "Target branch: ${{ github.event.pull_request.base.ref }}"
    - name: Run only when PR is merged
      if: > 
        github.event.action == 'closed' && 
        github.event.pull_request.merged == true     
      run: |
          echo "✅ Pull request was merged successfully!"



Task 2: PR Validation Workflow

name: PR Checks

on:
  pull_request:
    branches:
      - main

jobs:
  file-size-check:
    name: File size check (max 1 MB)
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Fail if any file exceeds 1 MB
        run: |
          echo "Checking for files larger than 1 MB in the PR..."
          MAX_SIZE=$((1024 * 1024))

          # List files changed in this PR
          git fetch origin ${{ github.base_ref }}
          FILES=$(git diff --name-only origin/${{ github.base_ref }}...HEAD)

          OVERSIZED=false
          for file in $FILES; do
            if [ -f "$file" ]; then
              SIZE=$(stat -c%s "$file")
              if [ "$SIZE" -gt "$MAX_SIZE" ]; then
                echo "::error::File '$file' is larger than 1 MB ($SIZE bytes)"
                OVERSIZED=true
              fi
            fi
          done

          if [ "$OVERSIZED" = true ]; then
            echo "❌ One or more files exceed the 1 MB limit"
            exit 1
          fi

          echo "✅ All files are within size limits"

  branch-name-check:
    name: Branch naming convention check
    runs-on: ubuntu-latest

    steps:
      - name: Validate branch name
        run: |
          BRANCH_NAME="${{ github.head_ref }}"
          echo "Checking branch name: $BRANCH_NAME"

          if [[ "$BRANCH_NAME" =~ ^(feature|fix|docs)/.+$ ]]; then
            echo "✅ Branch name follows convention"
          else
            echo "::error::Invalid branch name '$BRANCH_NAME'. Must start with feature/, fix/, or docs/"
            exit 1
          fi

  pr-body-check:
    name: PR description check (warning only)
    runs-on: ubuntu-latest

    steps:
      - name: Warn if PR body is empty
        run: |
          PR_BODY="${{ github.event.pull_request.body }}"

          if [ -z "$PR_BODY" ]; then
            echo "::warning::PR description is empty. Please add details for reviewers."
          else
            echo "✅ PR description is present"
          fi


Task 3: Scheduled Workflows (Cron Deep Dive)
name: Scheduled Tasks

on:
  schedule:
    # Every Monday at 02:30 AM UTC
    - cron: '30 2 * * 1'
    # Every 6 hours
    - cron: '0 */6 * * *'

jobs:
  scheduled-job:
    runs-on: ubuntu-latest

    steps:
      - name: Print which schedule triggered
        run: |
          echo "Workflow triggered by cron schedule:"
          echo "${{ github.event.schedule }}"

      - name: Health check - curl URL
        run: |
          URL="https://example.com"
          echo "Running health check for $URL"

          STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
          echo "HTTP status code: $STATUS_CODE"

          if [ "$STATUS_CODE" -ne 200 ]; then
            echo "::error::Health check failed with status code $STATUS_CODE"
            exit 1
          fi

          echo "✅ Health check passed"

The cron expression for: every weekday at 9 AM IST : convert to ust first which is 3.30 am 30 3 * * 1-5
The cron expression for: first day of every month at midnight : 0 0 1 * *

GitHub may delay or skip scheduled (cron) workflows on inactive repositories because there’s been no activity for a long time (about 60 days).
This helps GitHub save compute resources and prevent abuse like forgotten or malicious jobs running forever.
Only schedule-triggered workflows are affected—push, PR, or manual runs still work normally.
Once the repo has any activity again, scheduled workflows usually resume.
