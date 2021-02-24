FROM node:15.10.0-stretch-slim@sha256:325e465ccc8a02ada4db47e940c93b2734014cbed036db0a53d8ecc68abf0fc6 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.10.0-stretch-slim@sha256:325e465ccc8a02ada4db47e940c93b2734014cbed036db0a53d8ecc68abf0fc6 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]