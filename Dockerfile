FROM node:16.3.0-stretch-slim@sha256:8945e1fb267db7281e6d7dad16bf9793717c6c2efb89376a3c7b736fec347cc1 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.3.0-stretch-slim@sha256:8945e1fb267db7281e6d7dad16bf9793717c6c2efb89376a3c7b736fec347cc1 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]