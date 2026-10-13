FROM node:18-alpine AS build

WORKDIR /usr/src/node/server

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY tsconfig.json ./
COPY src ./src
RUN yarn build

FROM node:18-alpine AS runtime

ENV NODE_ENV=production

WORKDIR /usr/src/node/server

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production && yarn cache clean

COPY --from=build --chown=node:node /usr/src/node/server/build ./build

USER node

EXPOSE 3000

CMD ["node", "./build/index.js"]
