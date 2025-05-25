#!/bin/bash

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

if [ "$1" == "docker" ]; then
    print_header "Installing Docker on all hosts"
    
    print_step "Step 1: Testing connectivity to hosts"
    ansible-playbook playbooks/ping.yml
    
    print_step "Step 2: Installing Docker using the official installation script"
    ansible-playbook playbooks/install_docker.yml
    
    print_step "Step 3: Verifying Docker installation"
    ansible all -m command -a "docker --version"
    
    print_header "Docker installation complete"
    exit 0
fi

#if [ "$1" == "webapp" ]; then
#    print_header "Deploying web application to web servers"
#
#    print_step "Step 1: Testing connectivity to web servers"
#    ansible-playbook -l web_servers playbooks/ping.yml
#
#    print_step "Step 2: Deploying Django application to web servers (VM1, VM2, VM3)"
#    ansible-playbook playbooks/deploy_webapp.yml
#
#    print_step "Step 3: Verifying web application deployment"
#    ansible web_servers -m command -a "docker ps"
#
#    print_header "Web application deployment complete!"
#    echo "You can now access your application at:"
#    echo "VM1: http://192.168.123.10:8000"
#    echo "VM2: http://192.168.123.11:8000"
#    echo "VM3: http://192.168.123.12:8000"
#    exit 0
#fi

if [ "$1" == "nginx-docker" ]; then
    print_header "Installing Nginx with Docker as reverse proxy on VM4"
    
    print_step "Step 1: Testing connectivity to proxy server"
    ansible-playbook -l proxy playbooks/ping.yml
    
    print_step "Step 2: Installing Nginx with Docker and setup as reverse proxy"
    ansible-playbook playbooks/nginx_docker.yml
    exit 0
fi

if [ "$1" == "prometheus" ]; then
    print_header "Setting up Prometheus monitoring with Docker"
    
    print_step "Step 1: Testing connectivity to monitoring server"
    ansible-playbook -l proxy playbooks/ping.yml
    
    print_step "Step 2: Installing Prometheus"
    ansible-playbook playbooks/prometheus_docker.yml
    
    print_header "Prometheus setup complete!"
    echo "You can access Prometheus at:"
    echo "http://192.168.123.13:9090"
    exit 0
fi

if [ "$1" == "grafana" ]; then
    print_header "Setting up Grafana monitoring with Docker"
    
    print_step "Step 1: Testing connectivity to monitoring server"
    ansible-playbook -l proxy playbooks/ping.yml
    
    print_step "Step 2: Installing Grafana"
    ansible-playbook playbooks/grafana_docker.yml
    
    print_header "Grafana setup complete!"
    echo "You can access Grafana at:"
    echo "http://192.168.123.13:3000"
    echo "Default Grafana credentials:"
    echo "Username: admin"
    echo "Password: admin"
    exit 0
fi

#if [ "$1" == "all" ] || [ -z "$1" ]; then
#    print_header "Deploying entire infrastructure"
#
#    print_step "Step 1: Testing connectivity to all hosts"
#    ansible-playbook playbooks/ping.yml
#
#    print_step "Step 2: Deploying full infrastructure"
#    ansible-playbook playbooks/all_at_once_deploy.yml
#    exit 0
#fi

exit 1