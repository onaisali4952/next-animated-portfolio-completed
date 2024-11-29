# Stage 1: Build the application
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /src/app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install only production dependencies first for efficiency
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the Next.js app
RUN npm run build

# Stage 2: Run the application
FROM node:18-alpine

# Set the working directory
WORKDIR /src/app

# Copy only the necessary files from the build stage
COPY --from=builder /src/app/package.json /src/app/package-lock.json ./
COPY --from=builder /src/app/.next ./.next
COPY --from=builder /src/app/public ./public

# Install only production dependencies
RUN npm install --production

# Expose the port the app will run on
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
