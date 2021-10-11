FROM node:16.11.0-stretch-slim@sha256:03815e16c3097ddbb2949ee070da69e1bfc639b9c3565cf1e34d710c17499a80 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.11.0-stretch-slim@sha256:03815e16c3097ddbb2949ee070da69e1bfc639b9c3565cf1e34d710c17499a80 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]