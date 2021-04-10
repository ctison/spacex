FROM node:15.14.0-stretch-slim@sha256:bf73277c25b0b2b616c5789914178ac92a84fc2c4807f5c347ce1f8cc73f6eaa as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.14.0-stretch-slim@sha256:bf73277c25b0b2b616c5789914178ac92a84fc2c4807f5c347ce1f8cc73f6eaa as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]