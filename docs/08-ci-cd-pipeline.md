# CI/CD Pipeline

## Current Workflow

The repository contains `.github/workflows/deploy.yml`.

It runs on:

- pushes to `main`
- manual `workflow_dispatch`

## Build Stage

The build job:

- checks out the repo
- sets up Docker Buildx
- logs in to Docker Hub
- builds `theepicbook/Dockerfile`
- pushes two tags:
  - `${GITHUB_SHA}`
  - `latest`

## Deploy Stage

The deploy job:

- connects to the Azure VM over SSH
- logs in to Docker Hub on the VM
- writes TLS files into `nginx/ssl`
- rewrites `.env`
- restarts the stack with `docker compose`

## Required Secrets and Variables

Examples used by the workflow:

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`
- `VM_HOST`
- `VM_USER`
- `SSH_PRIVATE_KEY`
- `NGINX_SSL_CERT_B64`
- `NGINX_SSL_KEY_B64`
- `MYSQL_USER`
- `MYSQL_PASSWORD`
- `MYSQL_ROOT_PASSWORD`
- `MYSQL_DATABASE` as a GitHub variable

## Important Note

As committed today, the workflow writes `IMAGE=${{ needs.build.outputs.image }}` into `.env`, but the Compose file reads `APP_IMAGE` and `APP_TAG`. That means SHA-based image pinning is not fully aligned yet.
