FROM node:14.14.0-stretch-slim@sha256:3f0e71eee1467ac6d0a16ea66da16e1e0092c56d7e06ebaf2695b5de175cd4d9 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:14.14.0-stretch-slim@sha256:3f0e71eee1467ac6d0a16ea66da16e1e0092c56d7e06ebaf2695b5de175cd4d9 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]