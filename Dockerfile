FROM node:14.9.0-stretch-slim@sha256:040560fdfa41fa258ce6cf6532243535403c9e8b9999e5df02b362cf317ecc16 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:14.9.0-stretch-slim@sha256:040560fdfa41fa258ce6cf6532243535403c9e8b9999e5df02b362cf317ecc16 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]