FROM node:15.11.0-stretch-slim@sha256:f61c974d54be986a23f41975e14c3e4fd5a81996bc02c081dc50283de27943fb as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.11.0-stretch-slim@sha256:f61c974d54be986a23f41975e14c3e4fd5a81996bc02c081dc50283de27943fb as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]