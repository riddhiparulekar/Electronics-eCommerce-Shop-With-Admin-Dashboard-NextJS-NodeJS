#1st build stage is for dependencies and to generate prisma client
FROM node:20-alpine AS depend
WORKDIR /app/server

RUN apk add --no-cache openssl

COPY package.json package-lock.json ./
COPY prisma ./prisma

RUN --mount=type=cache,target=/root/.npm npm ci --omit=dev
RUN npx prisma generate

#remove unnecessary files from node_modules to reduce image size
RUN find node_modules -name "*.md" -delete \
 && find node_modules -name "CHANGELOG*" -delete \
 && find node_modules -name "*.map" -delete \
 && find node_modules -name "*.ts" ! -name "*.d.ts" -delete \
 && find node_modules -type d \( -name "test" -o -name "tests" -o -name "__tests__" -o -name "docs" -o -name ".github" \) -exec rm -rf {} + 2>/dev/null; true

 #2nd build stage is for the application
FROM node:20-alpine AS runner
RUN apk add --no-cache openssl \
 && addgroup -S nodejs && adduser -S expressjs -G nodejs
WORKDIR /app/server

ENV NODE_ENV=production \
    PORT=3001

COPY --from=depend --chown=expressjs:nodejs /app/server/node_modules ./node_modules
COPY --from=depend --chown=expressjs:nodejs /app/server/prisma ./prisma
COPY --chown=expressjs:nodejs . .

RUN mkdir -p /app/public /app/server/logs \
 && chown expressjs:nodejs /app/public /app/server/logs

USER expressjs
EXPOSE 3001
CMD ["node", "app.js"]
