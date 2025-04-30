#!/bin/bash

# Deploy script for running Ansible playbooks

function print_header() {
    echo "========================================"
    echo "$1"
    echo "========================================"
}

function print_step() {
    echo ""
    echo "→ $1"
    echo ""
}

if [ "$1" == "ping" ]; then
    print_header "Testing connectivity to all hosts"
    ansible-playbook playbooks/ping.yml
    exit 0
fi

if [ "$1" == "fix-dns" ]; then
    print_header "Fixing DNS resolution issues on all hosts"
    ansible-playbook playbooks/fix_dns.yml
    exit 0
fi

if [ "$1" == "docker" ]; then
    print_header "Installing Docker on all hosts"
    
    print_step "Step 1: Testing connectivity to hosts"
    ansible-playbook playbooks/ping.yml
    
    print_step "Step 2: Fixing DNS resolution (adding Google DNS)"
    ansible-playbook playbooks/fix_dns.yml
    
    print_step "Step 3: Installing Docker using the official installation script"
    ansible-playbook playbooks/install_docker.yml
    
    print_step "Step 4: Verifying Docker installation"
    ansible all -m command -a "docker --version"
    
    print_header "Docker installation complete!"
    echo "You can now proceed to deploy the web application."
    exit 0
fi

if [ "$1" == "webapp" ]; then
    print_header "Deploying web application to web servers"
    ansible-playbook playbooks/deploy_webapp.yml
    exit 0
fi

if [ "$1" == "nginx" ]; then
    print_header "Configuring Nginx reverse proxy"
    ansible-playbook playbooks/configure_nginx.yml
    exit 0
fi

if [ "$1" == "nginx-docker" ]; then
    print_header "Installing Nginx with Docker as reverse proxy on VM4"
    ansible-playbook playbooks/nginx_docker.yml
    exit 0
fi

if [ "$1" == "all" ] || [ -z "$1" ]; then
    print_header "Deploying entire infrastructure"
    ansible-playbook playbooks/site.yml
    exit 0
fi

echo "Unknown command: $1"
echo "Usage: ./deploy.sh [ping|fix-dns|docker|webapp|nginx|nginx-docker|all]"
echo "  ping         - Test connectivity to all hosts"
echo "  fix-dns      - Fix DNS resolution issues on all hosts"
echo "  docker       - Install Docker on all hosts (includes DNS fix)"
echo "  webapp       - Deploy web application to web servers"
echo "  nginx        - Configure Nginx reverse proxy"
echo "  nginx-docker - Install Nginx with Docker as reverse proxy on VM4 (simple version)"
echo "  all          - Deploy entire infrastructure (default)"
exit 1 