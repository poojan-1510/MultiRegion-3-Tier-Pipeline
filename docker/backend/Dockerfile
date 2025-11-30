FROM node:20 AS installer

WORKDIR /app

COPY ./backend/package*.json ./

RUN npm install --production

FROM node:20-alpine AS builder

WORKDIR /app

COPY --from=installer /app/node_modules ./node_modules

COPY . .

EXPOSE 3001

CMD ["node", "server.js"]
