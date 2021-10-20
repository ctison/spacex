FROM node:17.0.0-stretch-slim@sha256:ab87ea10318387c7b81735f67ee74d51af48964ccf9dfa3e0b5f2fc8ed187892 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:17.0.0-stretch-slim@sha256:ab87ea10318387c7b81735f67ee74d51af48964ccf9dfa3e0b5f2fc8ed187892 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]