# docker-epicbook-app

This repo runs The EpicBook with Docker Compose v2:

- `proxy`: Nginx reverse proxy
- `app`: Node.js application
- `db`: MySQL 8

## Ubuntu VM Guide: Install Docker Compose v2 Cleanly

This guide assumes an Ubuntu 22.04 LTS or 24.04 LTS VM and uses Docker's official `apt` repository so Docker Engine, Buildx, and Compose v2 stay updateable through `apt`.

### 1. Remove old or conflicting Docker packages

```bash
sudo apt update
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)
sudo apt autoremove -y
```

Optional: if this VM is disposable and you want a true blank-slate Docker host, stop Docker and remove old engine data:

```bash
sudo systemctl stop docker docker.socket containerd 2>/dev/null || true
sudo rm -rf /var/lib/docker /var/lib/containerd
```

### 2. Add Docker's official Ubuntu repository

```bash
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
```

### 3. Install Docker Engine and Docker Compose v2

```bash
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 4. Verify the installation

```bash
sudo systemctl status docker --no-pager
sudo docker run hello-world
docker compose version
docker buildx version
```

Important: Compose v2 uses `docker compose` with a space, not `docker-compose`.

### 5. Optional: run Docker without `sudo`

```bash
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world
```

If group membership does not refresh inside the VM session, log out and back in. On some VMs, a reboot is the quickest fix.

## Run This Repo

### 1. Create the environment file

```bash
cp example.env .env
```

Edit `.env` and set real values for:

- `MYSQL_DATABASE`
- `MYSQL_USER`
- `MYSQL_PASSWORD`
- `MYSQL_ROOT_PASSWORD`
- `HTTP_PORT`
- `HTTPS_PORT`

For a normal VM setup, use `HTTP_PORT=80` and `HTTPS_PORT=443`. Make sure inbound ports `80` and `443` are allowed by your VM firewall or cloud security group.

Optional for registry-based deployments:

- `APP_IMAGE`
- `APP_TAG`

### 2. Generate a self-signed certificate for Nginx

On Ubuntu, install `openssl` if needed:

```bash
sudo apt install -y openssl
```

Then generate the certificate and private key:

```bash
sh nginx/generate-self-signed-cert.sh localhost
```

This creates:

- `nginx/ssl/nginx.crt`
- `nginx/ssl/nginx.key`

If you plan to browse by public IP or DNS name, replace `localhost` with that IP or hostname when running the script.

### 3. Start the stack

```bash
docker compose up -d --build
```

### 4. Check status and logs

```bash
docker compose ps
docker compose logs -f
```

### 5. Open the app

Visit:

```text
https://<your-vm-public-ip>:<HTTPS_PORT>
```

Notes:

- HTTP requests on port `80` are redirected to HTTPS.
- Your browser will show a warning because the certificate is self-signed. That is expected until you replace it with a certificate from a trusted CA.

## GitHub Actions Deployment

The workflow at `.github/workflows/build-push-deploy.yml` does four things on every push to `main` or manual run:

- logs into Docker Hub
- builds the app image from `theepicbook/Dockerfile`
- tags it as `DOCKERHUB_REPOSITORY:${GITHUB_SHA}`
- uploads the deployment files to your Azure VM and runs `docker compose` there

### GitHub secrets to add

- `DOCKERHUB_USERNAME`: your Docker Hub username
- `DOCKERHUB_TOKEN`: a Docker Hub access token
- `DOCKERHUB_REPOSITORY`: the full repository name, for example `your-user/epicbook-app`
- `AZURE_VM_HOST`: your VM public IP or DNS name
- `AZURE_VM_USERNAME`: your SSH username, for example `azureuser`
- `AZURE_VM_SSH_KEY`: the private SSH key GitHub Actions should use
- `AZURE_VM_APP_DIR`: the deployment directory on the VM, for example `/home/azureuser/docker-epicbook-app`

### VM prerequisites

- Docker Engine and Docker Compose v2 installed
- the SSH user can run `docker` and `docker compose`
- a valid `.env` file already present inside `AZURE_VM_APP_DIR`
- TLS files already present at `AZURE_VM_APP_DIR/nginx/ssl/nginx.crt` and `AZURE_VM_APP_DIR/nginx/ssl/nginx.key`

If the TLS files do not exist yet, SSH to the VM and run:

```bash
cd /home/azureuser/docker-epicbook-app
sh nginx/generate-self-signed-cert.sh <your-vm-public-ip-or-hostname>
```

## References

- Docker Engine on Ubuntu: https://docs.docker.com/engine/install/ubuntu/
- Docker Compose plugin on Linux: https://docs.docker.com/compose/install/linux/
- Linux post-install steps: https://docs.docker.com/engine/install/linux-postinstall/
