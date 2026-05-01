# Cloud Deployment Notes

## Azure VM

Terraform provisions:

- a resource group
- a virtual network and subnet
- a static public IP
- a network security group
- a Linux VM

The VM output of interest is `public_ip`.

## NSG Ports

The current Terraform NSG allows inbound:

- `22/tcp` for SSH
- `80/tcp` for HTTP
- `443/tcp` for HTTPS

These ports match the Nginx bindings in `docker-compose.yml`.

## Runtime URL

Expected access pattern:

- `http://<public_ip>` -> redirects to HTTPS
- `https://<public_ip>` -> serves the app through Nginx

If the TLS certificate was generated for a different hostname, the browser will warn even if the proxy is working.

## VM Bootstrap

Cloud-init currently installs `docker.io`, enables Docker, and adds the admin user to the `docker` group.

The Terraform VM image is still `UbuntuServer 18.04-LTS`.
