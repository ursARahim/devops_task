# DevOps Project: Automated Multi-VM Web Application Deployment with Monitoring

## Overview

This project demonstrates a complete DevOps workflow that includes environment setup, web application development, CI/CD deployment using GitHub Actions, and monitoring using Prometheus and Grafana. It involves manual setup, automation with Ansible, Dockerization, and system monitoring in a multi-VM environment.

---

## Table of Contents

- [Problem 1: Environment Setup](#problem-1-environment-setup)
  - [Task 1: Manual Setup](#task-1-manual-setup)
  - [Task 2: Automate Setup with Ansible](#task-2-automate-setup-with-ansible)
- [Problem 2: Web Application Development](#problem-2-web-application-development)
- [Problem 3: Deployment Pipeline](#problem-3-deployment-pipeline)
- [Problem 4: Monitoring](#problem-4-monitoring)
- [Testing](#testing)
- [Technologies Used](#technologies-used)

---

## Problem 1: Environment Setup

### Task 1: Manual Setup

**Virtual Machines Setup:**
- Create 3 VMs using Oracle VirtualBox or VMware Workstation.
- Install **Ubuntu Server 24.04 (No GUI)** on each VM.
- Assign IPs from the `192.168.123.0/24` subnet.
- Install **Docker** on each VM.

**Reverse Proxy Setup:**
- Create a 4th VM as a **Reverse Proxy**.
- Install **Docker**.
- Deploy **Nginx** using Docker.

### Task 2: Automate Setup with Ansible

Use Ansible playbooks to automate:
- Installation of system dependencies (e.g., Docker).
- Deployment of the web application on the 3 VMs.
- Nginx configuration on the reverse proxy VM.

---

## Problem 2: Web Application Development

Develop a simple web app with the following features:
- Displays the **hostname** of the VM it's running on.
- Shows the **current commit hash** of the deployed code.
- Dockerize the application.

---

## Problem 3: Deployment Pipeline

Use **GitHub Actions** for the CI/CD pipeline:

### Continuous Integration (CI):
- Build the Docker image.
- Push the image to **DockerHub**.

### Continuous Delivery (CD):
- Deploy the Docker image to the 3 web server VMs.

---

## Problem 4: Monitoring

### Monitoring Setup:
- Install **Prometheus** and **Grafana** on the reverse proxy VM.

### System Monitoring:
- Configure Prometheus to scrape metrics from the 3 web server VMs.
- Create a Grafana dashboard to visualize:
  - CPU usage
  - Memory usage
  - Disk usage
  - Network statistics

---

## Testing

- Ensure everything works by accessing the web application at:  
  **http://myapp.com**

---

## Technologies Used

- Ubuntu Server 24.04
- Docker
- Nginx
- Ansible
- GitHub Actions
- Prometheus
- Grafana
- VirtualBox / VMware

---