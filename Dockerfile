FROM node:16.11.0-stretch-slim@sha256:28560c439f385fa426a2f944a073b91c0e33e207355f7fa288fa5c7c77d191b6 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.11.0-stretch-slim@sha256:28560c439f385fa426a2f944a073b91c0e33e207355f7fa288fa5c7c77d191b6 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]