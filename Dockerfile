FROM node:20-alpine
RUN apk add --no-cache openssl

EXPOSE 3000

WORKDIR /app

# Copy package files first
COPY package.json package-lock.json* ./

# Install all dependencies (dev + prod) for building
RUN npm ci

# Copy source files
COPY . .

# Build
RUN npm run build

# Remove dev dependencies for smaller image
RUN npm prune --production

# Set production env for runtime
ENV NODE_ENV=production

CMD ["npm", "run", "docker-start"]
