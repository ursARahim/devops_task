# Docker Installation with DNS Fix Instructions

Since you're experiencing DNS resolution issues on some VMs, follow these steps to install Docker successfully on all your VMs.

## The Problem

Some of your VMs (vm1 and vm3) are having trouble resolving the domain `get.docker.com`, which prevents the Docker installation script from downloading.

Error message:
```
curl: (6) Could not resolve host: get.docker.com
```

## The Solution

We've updated the deployment script to automatically fix DNS issues before installing Docker. It will:

1. Add Google's DNS servers (8.8.8.8 and 8.8.4.4) to `/etc/resolv.conf` on all VMs
2. Then attempt to download and install Docker using the official script

## Instructions

Run the following command to install Docker on all VMs (with DNS fix):

```bash
./deploy.sh docker
```

This will:
1. Test connectivity to all hosts
2. Apply DNS fixes by adding Google's DNS servers
3. Install Docker using curl and the official installation script
4. Verify Docker installation

## If Problems Persist with Specific VMs

If some VMs still have issues, you can SSH into them and fix DNS manually:

```bash
# SSH into the problematic VM
ssh abdur@192.168.123.10  # For vm1
# or
ssh abdur@192.168.123.12  # For vm3

# Add Google DNS
sudo sh -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
sudo sh -c 'echo "nameserver 8.8.4.4" >> /etc/resolv.conf'

# Test if DNS works now
nslookup get.docker.com

# If it works, install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

## Verifying Docker Installation

After installation, verify Docker is installed on all VMs:

```bash
./deploy.sh ping  # Check connectivity
ansible all -m command -a "docker --version"  # Check Docker version on all VMs
```

## Next Steps

Once Docker is successfully installed on all VMs, proceed with deploying your web application:

```bash
./deploy.sh webapp  # Deploy web application
./deploy.sh nginx   # Configure Nginx reverse proxy
``` 