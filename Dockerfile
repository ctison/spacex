FROM node:16.9.0-stretch-slim@sha256:71511a47ac34c4f6690fb0823e9dafcf146a3dc0c275f8da13a708a8e5352e71 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.9.0-stretch-slim@sha256:71511a47ac34c4f6690fb0823e9dafcf146a3dc0c275f8da13a708a8e5352e71 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]