FROM node:15.6.0-stretch-slim@sha256:01faeeed7eb949dbaa66272c3fa2110433dae7d96cd1b3722c3794c39f579c0f as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.6.0-stretch-slim@sha256:01faeeed7eb949dbaa66272c3fa2110433dae7d96cd1b3722c3794c39f579c0f as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]