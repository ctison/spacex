FROM node:15.3.0-stretch-slim@sha256:d1a1ab247f0b2487191e9498cfcb4a5b6c62a403cbe73dcd3c6d344e6a493483 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.3.0-stretch-slim@sha256:d1a1ab247f0b2487191e9498cfcb4a5b6c62a403cbe73dcd3c6d344e6a493483 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]