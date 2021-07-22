FROM node:16.5.0-stretch-slim@sha256:fa69bf929170dc774fdd71a743e7a83f549d7914cf8a677cbafb77132ed863b0 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.5.0-stretch-slim@sha256:fa69bf929170dc774fdd71a743e7a83f549d7914cf8a677cbafb77132ed863b0 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]