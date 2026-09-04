# Build stage for dependencies
FROM node:20-alpine AS depend
WORKDIR /app
RUN apk add --no-cache openssl libc6-compat
COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm npm ci

#Build stage for the application
FROM node:20-alpine AS builder
WORKDIR /app
RUN apk add --no-cache openssl libc6-compat
COPY --from=depend /app/node_modules ./node_modules
COPY . .

ARG NEXT_PUBLIC_API_BASE_URL
ENV NEXT_PUBLIC_API_BASE_URL=${NEXT_PUBLIC_API_BASE_URL}

ARG DATABASE_URL="mysql://build:build@localhost:3306/build"
ARG NEXTAUTH_SECRET="build-time-placeholder"
ENV DATABASE_URL=${DATABASE_URL} \
    NEXTAUTH_SECRET=${NEXTAUTH_SECRET}

RUN npm run build

#Build stage for the production image
FROM node:20-alpine AS runner
WORKDIR /app
RUN apk add --no-cache openssl libc6-compat \
 && addgroup -S nodejs && adduser -S nextjs -G nodejs

ENV NODE_ENV=production \
    PORT=3000 \
    HOSTNAME=0.0.0.0

#standalone build of nextjs app copied
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

#prisma engine binaries copied 
COPY --from=builder --chown=nextjs:nodejs /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder --chown=nextjs:nodejs /app/node_modules/@prisma/client ./node_modules/@prisma/client

COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/public ./public-seed

COPY --chown=nextjs:nodejs --chmod=755 docker-entrypoint.web.sh ./docker-entrypoint.web.sh

USER nextjs
EXPOSE 3000
ENTRYPOINT ["./docker-entrypoint.web.sh"]
CMD ["node", "server.js"]
