# Use the official Node.js image as a parent image
FROM node:18-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install any needed packages
RUN npm install

# Copy the rest of the application code to the working directory
COPY ./backend .

# Expose the port the app runs on
EXPOSE 5000

# Run the application
CMD ["npm", "start"] 