FROM node:16.4.1-stretch-slim@sha256:8d983052ea14d1676eea0b2ca4e134c8cf29102a0279d1efbd6ae6589ad11b61 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.4.1-stretch-slim@sha256:8d983052ea14d1676eea0b2ca4e134c8cf29102a0279d1efbd6ae6589ad11b61 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]