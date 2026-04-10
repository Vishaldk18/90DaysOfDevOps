## 🔹 Task 1: Prepare
- Using AI Bank App  
- Added GitHub secrets:
  - `DOCKERHUB_USERNAME`
  - `DOCKERHUB_TOKEN`

---

## 🔹 Task 2: Build the Docker Image in CI

- Build Docker image using GitHub Actions  
- Command:
```bash
docker build -t ai-bank-app:latest .
````

---

## 🔹 Task 3: Push to Docker Hub

* Login using secrets
* Push image to Docker Hub

---

## 🔹 Task 4: Only Push on Main

* Ensure images are pushed only when branch is `main`

---

## 🔹 Task 5: Add a Status Badge

```md
[![ai-bank-app-workflow](https://github.com/Vishaldk18/ai-bankapp-microservices/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/Vishaldk18/ai-bankapp-microservices/actions/workflows/docker-publish.yml)
```

---

## 🔹 GitHub Actions Workflow

```yaml
name: ai-bank-app-workflow

on:
  workflow_dispatch:

jobs:
  deploy-app:
    runs-on: ubuntu-latest

    steps:
      - name: checkout code
        uses: actions/checkout@v4

      - name: build docker image
        run: docker build -t ai-bank-app:latest .

      - name: docker login
        env:
          DOCKERHUB_USERNAME: ${{ secrets.DOCKERHUB_USERNAME }}
          DOCKERHUB_TOKEN:  ${{ secrets.DOCKERHUB_TOKEN }}
        run: |
          echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin

      - name: Get short SHA
        run: echo "SHORT_SHA=${GITHUB_SHA::7}" >> $GITHUB_ENV

      - name: tag the image
        run: |
          docker tag ai-bank-app:latest ${{ secrets.DOCKERHUB_USERNAME }}/ai-bank-app:latest
          docker tag ai-bank-app:latest ${{ secrets.DOCKERHUB_USERNAME }}/ai-bank-app:sha-$SHORT_SHA

      - name: push the image
        if: ${{ github.ref_name == 'main' }}
        run: |
          docker push ${{ secrets.DOCKERHUB_USERNAME }}/ai-bank-app:latest
          docker push ${{ secrets.DOCKERHUB_USERNAME }}/ai-bank-app:sha-$SHORT_SHA
```

---

## 🔹 Workflow Status Badge

[![ai-bank-app-workflow](https://github.com/Vishaldk18/ai-bankapp-microservices/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/Vishaldk18/ai-bankapp-microservices/actions/workflows/docker-publish.yml)

---

## 🧠 CI/CD Flow Explanation

> After a git push, GitHub Actions triggers a workflow that builds and tests the code, creates a Docker image, pushes it to a container registry, and then a deployment step pulls the image and runs it as a container on a server.
