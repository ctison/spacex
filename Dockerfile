FROM node:16.9.1-stretch-slim@sha256:b81c445e7e0b8cdd8df286d84657c0f6a3ae2fffa18d9b8d081b25a38dc4aaf5 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.9.1-stretch-slim@sha256:b81c445e7e0b8cdd8df286d84657c0f6a3ae2fffa18d9b8d081b25a38dc4aaf5 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]