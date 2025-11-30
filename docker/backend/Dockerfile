FROM node:20 AS installer

WORKDIR /app

# Correct path
COPY ./app/backend/package*.json ./

RUN npm install --production

FROM node:20-alpine AS builder

WORKDIR /app

COPY --from=installer /app/node_modules ./node_modules

# Correct path
COPY ./app/backend .

EXPOSE 3001

CMD ["node", "server.js"]
