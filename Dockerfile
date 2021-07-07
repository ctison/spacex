FROM node:16.4.2-stretch-slim@sha256:dcf946a135c1f79e4877f1df273076243ead52daad21693a1b1f963b18471cd9 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.4.2-stretch-slim@sha256:dcf946a135c1f79e4877f1df273076243ead52daad21693a1b1f963b18471cd9 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]