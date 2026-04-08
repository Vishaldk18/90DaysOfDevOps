Task 1: Trigger on Pull Request
name: trigger-demo
on:
  pull_request:
    branches: [main]
    types: [opened,synchronize]
jobs:
  pr-check:
   runs-on: ubuntu-latest
   steps:
     - name: PR check running for branch
       run: echo "${{ github.ref_name }}"

  Task 2: Scheduled Trigger
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
