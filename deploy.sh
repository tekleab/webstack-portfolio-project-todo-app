#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

echo "Pulling latest code from main..."
git pull origin main

echo "Building backend..."
cd backend
npm install
npm run build

echo "Starting backend via pm2..."
pm2 restart todo-backend || pm2 start dist/index.js --name todo-backend
pm2 save

echo "Building frontend..."
cd ../frontend
npm install
npm run build

echo "Deployment complete. Frontend built at frontend/dist"
