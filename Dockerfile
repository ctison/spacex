FROM node:16.8.0-stretch-slim@sha256:3de45cb9e7e7849dfecf7f8aea08b19af219820e7d3241efb26d78b3f6937c39 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.8.0-stretch-slim@sha256:3de45cb9e7e7849dfecf7f8aea08b19af219820e7d3241efb26d78b3f6937c39 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]