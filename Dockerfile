FROM node:15.12.0-stretch-slim@sha256:e9bc9fb86a969a91c7ca150970a6ce980b8c4f19263153840a163e647117a86f as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.12.0-stretch-slim@sha256:e9bc9fb86a969a91c7ca150970a6ce980b8c4f19263153840a163e647117a86f as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]