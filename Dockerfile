FROM node:16.11.0-stretch-slim@sha256:09ae6fbb660103bb9cd45489248f807b66c3a4741caa259e087b4fb0419e7cb4 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.11.0-stretch-slim@sha256:09ae6fbb660103bb9cd45489248f807b66c3a4741caa259e087b4fb0419e7cb4 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]