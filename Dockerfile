# Step 1: Build stage
# Use the official Node.js 16 Alpine image as the base image
FROM node:16-alpine AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock if using Yarn)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of your application code to the container
COPY . .

# Build the Next.js application
RUN npm run build

# Step 2: Production stage
# Use the official Node.js 16 Alpine image for the production environment
FROM node:16-alpine AS production

# Set the working directory in the container
WORKDIR /app

# Copy the built Next.js application from the builder stage
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules

# Expose the port the app runs on
EXPOSE 3000

# Command to run your app
CMD ["npm", "start"]