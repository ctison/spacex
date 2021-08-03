FROM node:16.6.1-stretch-slim@sha256:3180ae7d6945c8b24cb7ae7549d8eae4fc40c745234386c4df18636b49379292 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.6.1-stretch-slim@sha256:3180ae7d6945c8b24cb7ae7549d8eae4fc40c745234386c4df18636b49379292 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]