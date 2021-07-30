FROM node:16.6.0-stretch-slim@sha256:f841308b89aeff298580f740e64559557a4f2b95d14434c7df4290141180f89d as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.6.0-stretch-slim@sha256:f841308b89aeff298580f740e64559557a4f2b95d14434c7df4290141180f89d as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]