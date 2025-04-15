# DevOps Automation with Ansible

This project contains Ansible playbooks to automate the deployment of a web application infrastructure with Docker and Nginx reverse proxy.

## Infrastructure

- 3 VMs (192.168.123.10, 192.168.123.11, 192.168.123.12) running Ubuntu 24.04 for the web application
- 1 VM (192.168.123.13) running Ubuntu 24.04 as the Nginx reverse proxy

## Prerequisites

- All VMs should have Ubuntu 24.04 installed
- All VMs should have the same username (abdur) and password (16051)
- Python 3 installed on all VMs
- Ansible installed on the control machine

## Project Structure

- `inventory/`: Contains the inventory files with host definitions
- `roles/`: Contains the Ansible roles
  - `common/`: Installs Docker on all VMs using the official Docker installation script
  - `web_app/`: Deploys a web application on the web server VMs
  - `nginx_proxy/`: Configures the Nginx reverse proxy
- `playbooks/`: Contains the main playbook files

## Setup

1. The inventory file is already configured with your VM IP addresses and credentials
2. Verify connectivity to all VMs using the ping playbook

## Running the Playbooks

### Using the Deployment Script

The project includes a convenience script to run the playbooks:

```bash
# Make the script executable
chmod +x deploy.sh

# Test connectivity to all hosts
./deploy.sh ping

# Install Docker on all hosts
./deploy.sh docker

# Deploy web application to web servers
./deploy.sh webapp

# Configure Nginx reverse proxy
./deploy.sh nginx

# Deploy entire infrastructure (default)
./deploy.sh all
# or simply
./deploy.sh
```

### Using Ansible Directly

To deploy the entire infrastructure:

```bash
ansible-playbook -i inventory/hosts.ini playbooks/site.yml
```

To run specific roles:

```bash
# Install Docker only
ansible-playbook -i inventory/hosts.ini playbooks/site.yml --tags "common"

# Deploy web application only
ansible-playbook -i inventory/hosts.ini playbooks/site.yml --tags "web_app"

# Configure Nginx reverse proxy only
ansible-playbook -i inventory/hosts.ini playbooks/site.yml --tags "nginx_proxy"
```

## Verification

After running the playbooks, you can verify the setup by:

1. Accessing the web application through the Nginx reverse proxy at http://192.168.123.13
2. Add an entry to your local hosts file to map `myapp.com` to 192.168.123.13 for complete testing

## Troubleshooting

- Check the Docker service status on each VM: `sudo systemctl status docker`
- Check if the containers are running: `docker ps`
- Check Nginx proxy logs: `docker logs nginx_proxy` 