FROM node:14.11.0-stretch-slim@sha256:6da83da0c1c595cfc12ab6dacfe6abc1d0f9cd08f781ed4f3835f2f446ec8713 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:14.11.0-stretch-slim@sha256:6da83da0c1c595cfc12ab6dacfe6abc1d0f9cd08f781ed4f3835f2f446ec8713 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]