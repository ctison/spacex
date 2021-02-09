FROM node:15.8.0-stretch-slim@sha256:f9e80a28662d58e91172ff0fbcc2155f388e7e88e3e2c0e346e8d4597dfe60fd as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.8.0-stretch-slim@sha256:f9e80a28662d58e91172ff0fbcc2155f388e7e88e3e2c0e346e8d4597dfe60fd as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]