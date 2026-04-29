# syntax=docker/dockerfile:1

FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

COPY . .

FROM node:20-alpine AS runtime

WORKDIR /app

COPY --from=builder /app ./

USER node

EXPOSE 8080

CMD ["npm", "start"]
