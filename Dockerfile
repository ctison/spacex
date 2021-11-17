FROM node:17.1.0-stretch-slim@sha256:2f845dce6270dc9d8f5584c2ff2f4a52df57ffddafb2a8069a1ced19bc84b208 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:17.1.0-stretch-slim@sha256:2f845dce6270dc9d8f5584c2ff2f4a52df57ffddafb2a8069a1ced19bc84b208 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]