# Deployment Instructions

This document provides step-by-step instructions for deploying the infrastructure.

## Prerequisites

1. Make sure all VMs are running:
   - 3 web server VMs (192.168.123.10, 192.168.123.11, 192.168.123.12)
   - 1 proxy VM (192.168.123.13)
   
2. Ensure all VMs have the same username (abdur) and password (16051).

3. Verify that you have Ansible installed on your control machine:
   ```bash
   ansible --version
   ```

## Deployment Steps

### 1. Clone the repository (if not already done)

```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. Test connectivity to all hosts

```bash
./deploy.sh ping
```

### 3. Deploy the entire infrastructure

Option 1: Deploy everything at once
```bash
./deploy.sh all
# or simply
./deploy.sh
```

Option 2: Deploy step by step
```bash
# Step 1: Install Docker on all hosts using the official Docker installation script
./deploy.sh docker

# Step 2: Deploy web application to web servers
./deploy.sh webapp

# Step 3: Configure Nginx reverse proxy
./deploy.sh nginx
```

### 4. Verify the deployment

1. Check if the web servers are running:
   ```bash
   # SSH into each web server VM and run:
   docker ps
   ```

2. Check if the Nginx proxy is running:
   ```bash
   # SSH into the proxy VM and run:
   docker ps
   ```

3. Access the web application through the Nginx reverse proxy:
   - Open a web browser and go to http://192.168.123.13
   - Or, if you've updated your hosts file, go to http://myapp.com

## Troubleshooting

### If Docker installation fails

```bash
# SSH into the affected VM and check the Docker service status
sudo systemctl status docker

# Check Docker installation logs
cat /var/log/docker-install.log

# Try to reinstall Docker
./deploy.sh docker
```

### If web application deployment fails

```bash
# SSH into the affected web server VM and check the Docker container
docker ps -a
docker logs webapp

# Try to redeploy the web application
./deploy.sh webapp
```

### If Nginx proxy configuration fails

```bash
# SSH into the proxy VM and check the Docker container
docker ps -a
docker logs nginx_proxy

# Check the Nginx configuration
docker exec -it nginx_proxy nginx -t

# Try to reconfigure the Nginx proxy
./deploy.sh nginx
``` 