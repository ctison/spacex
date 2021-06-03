FROM node:16.3.0-stretch-slim@sha256:1c1d201c3be2d98dd369648263db5baced9b2caf725cdba603c6edb13446e724 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.3.0-stretch-slim@sha256:1c1d201c3be2d98dd369648263db5baced9b2caf725cdba603c6edb13446e724 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]