# Deployment Guide

## Overview
This repository contains a backend service (`backend/`) and a frontend service (`frontend/`). The CI/CD pipeline below deploys the backend service to a Linux server using GitHub Actions and `pm2`.

## Server Setup
1. SSH into the server.
2. Update packages:
   ```bash
   sudo apt update
   ```
3. Install Node.js 18 and npm:
   ```bash
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs
   ```
4. Install PM2 and Git:
   ```bash
   sudo npm install -g pm2
   sudo apt install git -y
   ```
5. Create the app directory and set ownership:
   ```bash
   sudo mkdir -p /home/dev/project/todo-app
   sudo chown $USER:$USER /home/dev/project/todo-app
   ```
6. Clone the repository:
   ```bash
   cd /home/dev/project/todo-app
   git clone https://github.com/YOUR_USERNAME/webstack-portfolio-project-todo-app .
   ```
7. Make the deploy script executable:
   ```bash
   chmod +x deploy.sh
   ```

## Environment Variables
The backend service needs the following environment variables set on the server:
- `DB_HOST` (optional, default `localhost`)
- `DB_USER`
- `DB_PASSWORD`
- `DB_NAME`
- `DB_PORT` (optional, default `3306`)
- `FRONTEND_API_KEY` (optional)

You can export these variables in the shell or configure them via a process manager like PM2.
For example:
```bash
export DB_HOST=127.0.0.1
export DB_USER=mydbuser
export DB_PASSWORD=mydbpassword
export DB_NAME=todo_app
export DB_PORT=3307
export FRONTEND_API_KEY=front-end-api-key
```

If Docker is used for MySQL and port `3306` is unavailable, use a different host port:
```bash
docker run -d --name todo-mysql \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -e MYSQL_DATABASE=todo \
  -e MYSQL_USER=todo \
  -e MYSQL_PASSWORD=todo \
  -p 3308:3306 \
  mysql:8
```

Then set `DB_HOST=127.0.0.1` and `DB_PORT=3308` for the backend.

## Manual Deployment Steps
From the `/home/dev/project/todo-app` directory:
```bash
cd /home/dev/project/todo-app
bash deploy.sh
```

If the app is already running:
```bash
pm2 restart todo-backend
```

## CI/CD Pipeline
A GitHub Actions workflow is configured in `.github/workflows/deploy.yml`.

### How it works
- Trigger: push to `main`
- Action: SSH into the Linux server
- Commands executed on the server:
  - `cd /var/www/todo-app`
  - `git pull origin main`
  - `cd backend`
  - `npm install`
  - `npm run build`
  - `pm2 restart todo-backend || pm2 start dist/index.js --name todo-backend`

### Required GitHub Secrets
Add these secrets in the repository settings:
- `SERVER_HOST` - server IP address or hostname
- `SERVER_USER` - SSH username
- `SERVER_SSH_KEY` - SSH private key for `SERVER_USER` (optional if using password)
- `SERVER_PASSWORD` - SSH password for `SERVER_USER` (optional if using SSH key)

> If you want to deploy via GitHub Actions without an SSH key, set `SERVER_PASSWORD` and leave `SERVER_SSH_KEY` empty.

## Optional Nginx / Domain Setup
If you want to expose the frontend and backend through a domain, install and configure Nginx:
```bash
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
```
Create `/etc/nginx/sites-available/todo-app` with:
```nginx
server {
    listen 80;
    server_name your-domain.com;

    root /home/dev/project/todo-app/frontend/dist;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api/ {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```
Enable the site and reload Nginx:
```bash
sudo ln -s /etc/nginx/sites-available/todo-app /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

> Note: the frontend build files are generated in `/home/dev/project/todo-app/frontend/dist` by `npm run build`.

## Troubleshooting
- If the workflow fails, check GitHub Actions logs and ensure SSH secrets are correct.
- If deployment fails on the server, verify that `/var/www/todo-app` contains the correct repository and that `pm2` can access `dist/index.js`.
- Use `pm2 logs todo-backend` to inspect runtime errors.
- Use `sudo nginx -t` to validate Nginx configuration.
