FROM node:16.8.0-stretch-slim@sha256:04a66ab1e806fbb00db0f50222747ec5f9637aeb884053717b2e156b64ab9fc9 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.8.0-stretch-slim@sha256:04a66ab1e806fbb00db0f50222747ec5f9637aeb884053717b2e156b64ab9fc9 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]