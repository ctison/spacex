FROM node:14.10.0-stretch-slim@sha256:31d673d8e05165efce181d5d8473ac53f13b04609294c70f46d9d06e2cc3a8e6 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:14.10.0-stretch-slim@sha256:31d673d8e05165efce181d5d8473ac53f13b04609294c70f46d9d06e2cc3a8e6 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]