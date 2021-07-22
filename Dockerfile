FROM node:16.5.0-stretch-slim@sha256:a31977a0df1f58358d7126e3cfa9b73333c30de99ffb58b93fe638293e332d91 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.5.0-stretch-slim@sha256:a31977a0df1f58358d7126e3cfa9b73333c30de99ffb58b93fe638293e332d91 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]