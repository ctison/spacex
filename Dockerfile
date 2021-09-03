FROM node:16.8.0-stretch-slim@sha256:f68186997da6d088f8567c2f2f3246ff13aef26372a2c968e30e25ae029035bb as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.8.0-stretch-slim@sha256:f68186997da6d088f8567c2f2f3246ff13aef26372a2c968e30e25ae029035bb as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]