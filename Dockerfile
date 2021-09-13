FROM node:16.9.1-stretch-slim@sha256:999ab60ebeed2ad9ea9f9c56a070f49d105023dd9b741732dd45166bcba40ed3 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.9.1-stretch-slim@sha256:999ab60ebeed2ad9ea9f9c56a070f49d105023dd9b741732dd45166bcba40ed3 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]