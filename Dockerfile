FROM node:16.6.2-stretch-slim@sha256:73de8395098f79ce65c48a5f831a2f2ac02e56e604d044891619562dc8b830ed as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.6.2-stretch-slim@sha256:73de8395098f79ce65c48a5f831a2f2ac02e56e604d044891619562dc8b830ed as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]