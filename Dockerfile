# 1. Builder Stage
FROM node:20-alpine AS builder

WORKDIR /app

ENV YARN_CACHE_FOLDER=/tmp/yarn

COPY package.json yarn.lock ./
RUN yarn install --network-timeout 300000 

COPY . .
RUN yarn build

# 2. Runtime Image
FROM node:20-alpine

WORKDIR /app

ENV YARN_CACHE_FOLDER=/tmp/yarn

COPY package.json yarn.lock ./
RUN yarn install --production --network-timeout 300000 

COPY --from=builder /app /app

RUN mkdir -p /app/public/uploads

EXPOSE 1337

CMD ["yarn", "develop"]
