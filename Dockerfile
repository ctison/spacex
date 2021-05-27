FROM node:16.2.0-stretch-slim@sha256:3561ead7ca43139d26f9ec792f746b77a1a1536932653f329385d4b07ace8087 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.2.0-stretch-slim@sha256:3561ead7ca43139d26f9ec792f746b77a1a1536932653f329385d4b07ace8087 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]