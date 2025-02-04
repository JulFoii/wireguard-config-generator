# =============== STAGE 1: Build Frontend ===============
FROM node:18-bullseye AS frontend-build
WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# =============== STAGE 2: Build Backend ===============
FROM node:18-bullseye AS backend-build
WORKDIR /app/backend

COPY backend/package*.json ./
RUN npm install
COPY backend/ ./
RUN npm run build

# =============== STAGE 3: Production Image ===============
FROM node:18-bullseye

# Wenn du wg genkey etc. nutzen willst:
RUN apt-get update && apt-get install -y wireguard

WORKDIR /app

# Backend
COPY --from=backend-build /app/backend/dist ./backend/dist
COPY backend/package*.json ./backend/
RUN cd backend && npm install --only=production

# Frontend
COPY --from=frontend-build /app/frontend/dist ./frontend/build

EXPOSE 3000
CMD ["node", "backend/dist/server.js"]
