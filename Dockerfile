FROM node:15.11.0-stretch-slim@sha256:71f689ace0c14f4ff01cb4bc3b30477a4b2ca4a90f7cc98227c352c4706a1452 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.11.0-stretch-slim@sha256:71f689ace0c14f4ff01cb4bc3b30477a4b2ca4a90f7cc98227c352c4706a1452 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]