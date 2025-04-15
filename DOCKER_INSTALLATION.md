# Docker Installation Guide

This guide provides step-by-step instructions for installing Docker on all your VMs using Ansible.

## Prerequisites

- All 4 VMs are up and running with the following IP addresses:
  - VM1: 192.168.123.10
  - VM2: 192.168.123.11
  - VM3: 192.168.123.12
  - VM4: 192.168.123.13
- All VMs have the same username `abdur` and password `16051`
- Ansible is installed on your control machine

## Step 1: Verify Connectivity

First, test connectivity to all VMs using the ping playbook:

```bash
./deploy.sh ping
```

This will:
- Ping all hosts to verify network connectivity
- Display system information for each VM
- Confirm that the username and password are correct

## Step 2: Install Docker

Install Docker on all VMs using the official Docker installation script:

```bash
./deploy.sh docker
```

This will:
1. Test connectivity to all hosts
2. Install Docker using the official Docker installation script (https://get.docker.com)
3. Verify Docker installation by displaying the Docker version on each VM

## What Happens During Docker Installation?

The Docker installation process:

1. Updates the apt cache
2. Installs required packages (curl, ca-certificates)
3. Downloads the Docker installation script from https://get.docker.com
4. Runs the Docker installation script
5. Ensures the Docker service is running and enabled at boot
6. Adds your user to the docker group so you can run Docker commands without sudo
7. Verifies Docker installation by checking the Docker version

## Verification

After running the Docker installation, you can verify it manually by:

1. SSH into each VM:
   ```bash
   ssh abdur@192.168.123.10  # Replace with appropriate IP
   ```

2. Check Docker version:
   ```bash
   docker --version
   ```

3. Run a test container:
   ```bash
   docker run hello-world
   ```

## Next Steps

After successfully installing Docker on all VMs, you can proceed to:

1. Deploy the web application to the web server VMs:
   ```bash
   ./deploy.sh webapp
   ```

2. Configure the Nginx reverse proxy:
   ```bash
   ./deploy.sh nginx
   ```

## Troubleshooting

If Docker installation fails:

1. Check if Docker is already installed:
   ```bash
   which docker
   docker --version
   ```

2. Look for installation errors:
   ```bash
   sudo systemctl status docker
   ```

3. Try installing Docker manually on the problematic VM:
   ```bash
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh
   ``` 