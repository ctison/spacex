FROM node:15.5.0-stretch-slim@sha256:16e827c805749ab5cb0cdb95c89d3390c1c33939552d0154d58afb05356bffe2 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.5.0-stretch-slim@sha256:16e827c805749ab5cb0cdb95c89d3390c1c33939552d0154d58afb05356bffe2 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]