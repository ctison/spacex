FROM node:15.7.0-stretch-slim@sha256:e756c3068aa65d9d08afd9e9c55c6fd861aca8fd73122be8ad2d1bccb7dd8943 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.7.0-stretch-slim@sha256:e756c3068aa65d9d08afd9e9c55c6fd861aca8fd73122be8ad2d1bccb7dd8943 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]