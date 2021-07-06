FROM node:16.4.0-stretch-slim@sha256:12844ac30a40d3fbfc0a65d0d72f0cbc6ffc42f04d6660a5359a8851ad01cee5 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.4.0-stretch-slim@sha256:12844ac30a40d3fbfc0a65d0d72f0cbc6ffc42f04d6660a5359a8851ad01cee5 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]