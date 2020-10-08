FROM node:14.13.1-stretch-slim@sha256:b753f30157252f339d9f3631f4731a69690d02836ae8cddc6c5d6bf9bee2bab3 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:14.13.1-stretch-slim@sha256:b753f30157252f339d9f3631f4731a69690d02836ae8cddc6c5d6bf9bee2bab3 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]