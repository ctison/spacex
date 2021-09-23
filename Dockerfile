FROM node:16.10.0-stretch-slim@sha256:a0708ac9d278da7faffbda500405720d00d35c343f418ff6276b67f3c3e1ff8d as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.10.0-stretch-slim@sha256:a0708ac9d278da7faffbda500405720d00d35c343f418ff6276b67f3c3e1ff8d as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]