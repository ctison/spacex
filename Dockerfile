FROM node:17.2.0-stretch-slim@sha256:70be06d3afea4f1216a37d6455988e889384c9d7b9e4312db53fabbc7ec9545e as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:17.2.0-stretch-slim@sha256:70be06d3afea4f1216a37d6455988e889384c9d7b9e4312db53fabbc7ec9545e as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]