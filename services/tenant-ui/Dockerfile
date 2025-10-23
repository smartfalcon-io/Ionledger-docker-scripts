# Stage 1: Build frontend
FROM node:20-alpine AS frontend-builder
WORKDIR /app/frontend

# Copy only frontend
COPY frontend/package*.json ./
RUN npm install

COPY frontend ./
RUN npm run build

# Stage 2: Build backend
FROM node:20-alpine AS backend-builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 3: Serve frontend via Nginx
FROM nginx:1.27-alpine
# Copy Nginx config
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
# Copy compiled frontend
COPY --from=frontend-builder /app/frontend/dist /usr/share/nginx/tenant-ui
# Optionally copy default HTML (like favicon etc)
COPY frontend/public /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
