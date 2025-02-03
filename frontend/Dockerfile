# Dockerfile

FROM --platform=linux/amd64 node:22-slim as builder
WORKDIR /app
COPY ./package.json ./
RUN npm install --verbose
COPY . .
RUN npm run build

FROM --platform=linux/amd64 nginx:1.27.0-alpine-slim

EXPOSE 80

COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html

# Start Nginx server directly
CMD ["nginx", "-g", "daemon off;"]