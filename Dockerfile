# Dockerfile

FROM --platform=linux/amd64 node:22-alpine as builder
WORKDIR /app
COPY ./package.json ./
RUN npm install
COPY . .
RUN npm run build

FROM --platform=linux/amd64 nginx:1.27.0-alpine-slim

ARG REACT_APP_SPLIT_SDK_KEY

# Create the environment variables and assign the values from the build arguments.
ENV REACT_APP_SPLIT_SDK_KEY=$REACT_APP_SPLIT_SDK_KEY

EXPOSE 3000
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]