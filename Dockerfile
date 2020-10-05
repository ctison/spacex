FROM node:14.13.0-stretch-slim@sha256:8a1c2805842351c462d7482dea01600f92cae263146b2353f9e6e3f768d707a5 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:14.13.0-stretch-slim@sha256:8a1c2805842351c462d7482dea01600f92cae263146b2353f9e6e3f768d707a5 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]