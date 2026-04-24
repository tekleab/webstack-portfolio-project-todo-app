# 🚀 Todo App: CI/CD & Deployment Documentation

This document outlines the professional deployment architecture for the **Todo App**, a full-stack application featuring a React frontend and Node.js/Express backend.

---

## 🏗 System Architecture

The application is deployed using a modern "Pull-Based" CI/CD strategy.

```mermaid
graph TD
    A[Tekleab - Developer] -->|Push Code| B[GitHub Repository]
    B -->|Trigger Workflow| C[GitHub Actions]
    C -->|SSH & Execute Script| D[Linux Server]
    D -->|Git Pull| E[App Source]
    E -->|Build & PM2 Restart| F[Backend API :3000]
    E -->|Build Static Files| G[Frontend Dist]
    H[User Browser] -->|HTTP :80| I[Nginx Reverse Proxy]
    I -->|Serve Static| G
    I -->|Proxy /api Requests| F
```

---

## 🛠 Prerequisites & Server Prep

### 1. System Dependencies
The following core technologies were installed on the server:
- **Node.js 18.x**: Runtime for backend and build tools.
- **PM2**: Production process manager for Node.js.
- **Git**: For source control management.
- **Nginx**: High-performance reverse proxy.

### 2. Database Layer
The app requires a MySQL database. For quick setup, we can use a local MySQL instance or a Docker container:
```bash
docker run -d --name todo-mysql \
  -e MYSQL_ROOT_PASSWORD=yourpassword \
  -p 3306:3306 \
  mysql:8
```

---

## 🔗 CI/CD Pipeline Flow

The automation is handled via `.github/workflows/deploy.yml`. 

### Key Features:
- **Automated Deploy**: Every push to the `main` branch triggers an instant update.
- **Secure Credentials**: Sensitive info (IP, SSH Keys) is stored securely in **GitHub Secrets**.
- **Self-Healing Script**: The `deploy.sh` script automatically performs clean installs and restarts the backend via PM2.

### Required Secrets:
| Secret Name | Description |
| :--- | :--- |
| `SERVER_HOST` | Remote server IP address (e.g., 196.188.187.153) |
| `SERVER_USER` | SSH Username (e.g., dev) |
| `SERVER_SSH_KEY` | Private key for passwordless login |
| `SERVER_PASSWORD` | Fallback SSH password |

---

## 🌐 Nginx Reverse Proxy Configuration

Nginx is configured to serve the frontend dist folder while proxying `/api` calls to the local Node.js process.

**Configuration Snippet:**
```nginx
location / {
    try_files $uri $uri/ /index.html; # React Router support
}

location /api/ {
    proxy_pass http://localhost:3000; # Pass to Node.js Backend
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

---

## 🩺 Troubleshooting & Maintenance

- **View Logs**: `pm2 logs todo-backend`
- **Check Status**: `pm2 status`
- **Verify Nginx**: `sudo nginx -t`
- **Environment Variables**: Ensure `.env` is configured correctly in `/home/dev/project/todo-app/backend/`.

---

**Developed & Deployed by Tekleab.**
