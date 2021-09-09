FROM node:16.9.0-stretch-slim@sha256:b4f57f7282299873113b8324e3aecb77117a3a19fcc90fea2b49ab92fadef74b as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.9.0-stretch-slim@sha256:b4f57f7282299873113b8324e3aecb77117a3a19fcc90fea2b49ab92fadef74b as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]