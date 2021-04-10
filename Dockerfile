FROM node:15.14.0-stretch-slim@sha256:bf72220621aeee1dadef28c759f4255b651b461861d071b455ec83d185d52e55 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.14.0-stretch-slim@sha256:bf72220621aeee1dadef28c759f4255b651b461861d071b455ec83d185d52e55 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]