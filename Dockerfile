# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
# Installer pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate
# Copier les fichiers de configuration
COPY package.json package-lock.json* ./

# Installer les dépendances
RUN npm install

# Copier le code source
COPY . .

# Builder l'application
RUN npm run build

# Stage 2: Production
FROM node:20-alpine
WORKDIR /app
# Installer pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate
# Copier les fichiers nécessaires
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
# Exposer le port
EXPOSE 3000

# Démarrer l'application
CMD ["node", "dist/main"]