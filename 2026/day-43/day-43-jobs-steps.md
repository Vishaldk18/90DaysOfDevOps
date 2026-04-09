Task 1: Multi-Job Workflow
name: multi-job
on:
  workflow_dispatch
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

Task 2: Environment Variables
name: env-check
on:
  workflow_dispatch
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

Task 3: Job Outputs
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
