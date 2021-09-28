FROM node:16.10.0-stretch-slim@sha256:7abc58e50c7448af3798d08717998ad958b959b4e0708f1c5cad6b3ea4decb6d as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.10.0-stretch-slim@sha256:7abc58e50c7448af3798d08717998ad958b959b4e0708f1c5cad6b3ea4decb6d as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]