FROM node:15.5.1-stretch-slim@sha256:eb4d3319d7f7265af9b59573ab3bd0a3ce1af90fb24a192ff62d4fa85caeaa14 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.5.1-stretch-slim@sha256:eb4d3319d7f7265af9b59573ab3bd0a3ce1af90fb24a192ff62d4fa85caeaa14 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]