# Use the official Node.js image as a parent image
FROM --platform=linux/amd64 node:18-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY backend/package*.json ./

# Install any needed packages
RUN npm install

# Copy the backend application code
COPY backend/ .

# Expose the port the app runs on
EXPOSE 5000

# Run the application
CMD ["npm", "start"] 