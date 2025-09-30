# Step 1: Builder stage
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy project files
COPY . .

# Build Next.js app
RUN npm run build


# Step 2: Runner stage
FROM node:20-alpine AS runner

WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

# Set port via env
ENV PORT=5000
EXPOSE 5000

# Start Next.js
CMD ["npm", "start"]
