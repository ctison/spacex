FROM node:15.8.0-stretch-slim@sha256:7b2d32de2a02e13e67ae58114cf0095b81c6bb33ee0ce0e6368800b7c36178e3 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.8.0-stretch-slim@sha256:7b2d32de2a02e13e67ae58114cf0095b81c6bb33ee0ce0e6368800b7c36178e3 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]