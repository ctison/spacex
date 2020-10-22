FROM node:15.0.0-stretch-slim@sha256:e4cfc4c1e9fb7daccaad1fdbc28f1f7a4be9d925589578d8ffe809b5b49e93c7 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.0.0-stretch-slim@sha256:e4cfc4c1e9fb7daccaad1fdbc28f1f7a4be9d925589578d8ffe809b5b49e93c7 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]