FROM node:15.14.0-stretch-slim@sha256:6fb6afd92afc04e8a10db9a4ac26a03ced01e42838c89da647b58b2abf6bbb28 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.14.0-stretch-slim@sha256:6fb6afd92afc04e8a10db9a4ac26a03ced01e42838c89da647b58b2abf6bbb28 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]