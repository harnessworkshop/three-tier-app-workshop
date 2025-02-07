# Build stage
FROM --platform=linux/amd64 node:18-slim as builder
WORKDIR /app

# Copy package files first for better caching
COPY frontend/package*.json ./
RUN npm install --verbose

# Copy frontend source code
COPY frontend/ .

# Build the application
RUN npm run build

# Production stage
FROM --platform=linux/amd64 nginx:1.25.3-alpine-slim

EXPOSE 80

# Copy Nginx configuration and built files
COPY frontend/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"] 