FROM node:16.2.0-stretch-slim@sha256:586a1b4d16e3ec164acaa4191bb9f895079d52bad8e8d42fd963a7bb00488376 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.2.0-stretch-slim@sha256:586a1b4d16e3ec164acaa4191bb9f895079d52bad8e8d42fd963a7bb00488376 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]