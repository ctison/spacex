FROM node:15.2.1-stretch-slim@sha256:582ee8eefa443ffae7c3b84bf40c806f9c1ac890e9da5c26cbfcd315bd6354a5 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.2.1-stretch-slim@sha256:582ee8eefa443ffae7c3b84bf40c806f9c1ac890e9da5c26cbfcd315bd6354a5 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]