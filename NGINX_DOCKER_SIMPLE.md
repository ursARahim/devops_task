# Simple Nginx Docker Installation

This guide shows how to set up Nginx using Docker on VM4 as a reverse proxy for Django applications running on VM1, VM2, and VM3.

## Quick Start

Run the following command to deploy Nginx on VM4:

```bash
./deploy.sh nginx-docker
```

## What This Does

1. Creates a directory for the Nginx configuration on VM4: `/home/abdur/nginx-proxy/`
2. Creates an Nginx configuration file that:
   - Sets up load balancing across all three web servers (VM1, VM2, VM3)
   - Configures proper proxy headers
   - Handles static files
3. Runs an Nginx Docker container with the configuration mounted

## Nginx Configuration

The configuration sets up an upstream server group with all three Django application servers and configures Nginx to proxy requests to them.

## Verification

After running the deployment, you can:

1. SSH into VM4:
   ```bash
   ssh abdur@192.168.123.13
   ```

2. Check if the Nginx container is running:
   ```bash
   docker ps | grep nginx-proxy
   ```

3. Test accessing your Django application through the Nginx proxy:
   ```bash
   curl -I http://localhost
   ```

4. Access your application in a browser at `http://192.168.123.13`

## Manual Installation

If you prefer to install manually:

1. SSH into VM4
2. Create a directory for Nginx configuration:
   ```bash
   mkdir -p ~/nginx-proxy
   ```

3. Create the Nginx configuration file:
   ```bash
   nano ~/nginx-proxy/nginx.conf
   ```

   Paste the following content:
   ```
   user  nginx;
   worker_processes  auto;
   error_log  /var/log/nginx/error.log;
   pid        /var/run/nginx.pid;

   events {
       worker_connections  1024;
   }

   http {
       include       /etc/nginx/mime.types;
       default_type  application/octet-stream;
       log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                       '$status $body_bytes_sent "$http_referer" '
                       '"$http_user_agent" "$http_x_forwarded_for"';
       access_log  /var/log/nginx/access.log  main;
       sendfile        on;
       keepalive_timeout  65;

       upstream django_app {
           server 192.168.123.10:8000;
           server 192.168.123.11:8000;
           server 192.168.123.12:8000;
       }

       server {
           listen       80;
           server_name  _;

           location /static/ {
               proxy_pass http://192.168.123.10:8000;
               proxy_set_header Host $host;
               proxy_set_header X-Real-IP $remote_addr;
           }

           location / {
               proxy_pass http://django_app;
               proxy_set_header Host $host;
               proxy_set_header X-Real-IP $remote_addr;
               proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
               proxy_redirect off;
           }
       }
   }
   ```

4. Run the Nginx Docker container:
   ```bash
   docker run -d --name nginx-proxy -p 80:80 -v ~/nginx-proxy/nginx.conf:/etc/nginx/nginx.conf:ro --restart=always nginx:latest
   ``` 