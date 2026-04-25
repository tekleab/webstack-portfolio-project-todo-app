# ALX - Webstack - Portfolio Project

![Build & Deploy Status](https://github.com/tekleab/webstack-portfolio-project-todo-app/actions/workflows/deploy.yml/badge.svg)

A simple to-do application that allows users to create and delete tasks.

**Author:** Biruk Ephrem

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        TODO APPLICATION                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌─────────────────┐          HTTP/API          ┌───────────┐ │
│   │    FRONTEND     │ ◄───────────────────────► │  BACKEND   │ │
│   │    (React)      │     (API Key Auth)         │ (Node.js)  │ │
│   └─────────────────┘                            └─────┬─────┘ │
│          │                                             │       │
│          │                                             │       │
│   ┌──────┴──────┐                              ┌──────┴──────┐ │
│   │   Pages:    │                              │  Modules:   │ │
│   │  - Login    │                              │  - User     │ │
│   │  - Signup   │                              │  - Todo     │ │
│   │  - Home     │                              │  - API Key  │ │
│   └─────────────┘                              └──────┬──────┘ │
│                                                       │        │
│                                                       ▼        │
│                                               ┌─────────────┐  │
│                                               │    MySQL    │  │
│                                               │  (TypeORM)  │  │
│                                               └─────────────┘  │
│                                                                │
└─────────────────────────────────────────────────────────────────┘
```

## Services

| Service | Tech Stack | Depends On | Purpose |
|---------|------------|------------|---------|
| **Frontend** | React, Vite | Backend Service | User interface for managing todos |
| **Backend** | Node.js, TypeScript, Express | MySQL Database | REST API for CRUD operations |
| **Database** | MySQL + TypeORM | - | Persistent storage for users & todos |

## Data Flow

1. **User** visits the React frontend
2. **Frontend** sends HTTP requests to the Backend (optionally secured with API key)
3. **Backend** processes requests via Express middleware
4. **TypeORM** queries/updates the MySQL database
5. **Response** flows back to the user

## Getting Started

See individual service READMEs for setup instructions:
- [Backend](./backend/README.md)
- [Frontend](./frontend/README.md)
- [Deployment Guide](./DEPLOYMENT.md)

> **Note:** Start the backend service first, as the frontend depends on it.
