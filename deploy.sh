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
    
    print_step "Step 1: Testing connectivity to web servers"
    ansible-playbook -l web_servers playbooks/ping.yml
    
    print_step "Step 2: Deploying Django application to web servers (VM1, VM2, VM3)"
    ansible-playbook playbooks/deploy_webapp.yml
    
    print_step "Step 3: Verifying web application deployment"
    ansible web_servers -m command -a "docker ps"
    
    print_header "Web application deployment complete!"
    echo "You can now access your application at:"
    echo "VM1: http://192.168.123.10:8000"
    echo "VM2: http://192.168.123.11:8000"
    echo "VM3: http://192.168.123.12:8000"
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

if [ "$1" == "prometheus" ]; then
    print_header "Setting up Prometheus monitoring with Docker"
    
    print_step "Installing Prometheus"
    ansible-playbook playbooks/prometheus_docker.yml
    
    print_header "Prometheus setup complete!"
    echo "You can access Prometheus at:"
    echo "http://192.168.123.13:9090"
    exit 0
fi

if [ "$1" == "grafana" ]; then
    print_header "Setting up Grafana monitoring with Docker"
    
    print_step "Installing Grafana"
    ansible-playbook playbooks/grafana_docker.yml
    
    print_header "Grafana setup complete!"
    echo "You can access Grafana at:"
    echo "http://192.168.123.13:3000"
    echo "Default Grafana credentials:"
    echo "Username: admin"
    echo "Password: admin"
    exit 0
fi

echo "Unknown command: $1"
echo "Usage: ./deploy.sh [ping|fix-dns|docker|webapp|nginx|nginx-docker|reload-nginx|setup-domain|all]"
echo "  ping         - Test connectivity to all hosts"
echo "  fix-dns      - Fix DNS resolution issues on all hosts"
echo "  docker       - Install Docker on all hosts (includes DNS fix)"
echo "  webapp       - Deploy web application to web servers"
echo "  nginx        - Configure Nginx reverse proxy"
echo "  nginx-docker - Install Nginx with Docker as reverse proxy on VM4"
echo "  reload-nginx - Reload Nginx configuration without container restart"
echo "  setup-domain - Configure domain access with myapp.com"
echo "  all          - Deploy entire infrastructure (default)"
exit 1 