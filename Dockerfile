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

# Copy .env file and shell script to container
WORKDIR /usr/share/nginx/html
COPY ./env.sh .
COPY .env .

# Add bash
RUN apk add --no-cache bash

# Make our shell script executable
RUN chmod +x env.sh

# Start Nginx server
CMD ["/bin/bash", "-c", "/usr/share/nginx/html/env.sh && nginx -g \"daemon off;\""]