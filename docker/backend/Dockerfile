FROM node:20-alpine AS installer

WORKDIR /app

COPY app/backend/package*.json ./

RUN npm install --production

FROM node:20-alpine AS builder

WORKDIR /app

COPY --from=installer /app/node_modules ./node_modules

COPY app/backend/ .

EXPOSE 3000

CMD ["node", "server.js"]
