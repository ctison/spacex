FROM node:15.7.0-stretch-slim@sha256:4be769bb8d805184339e117a8f63d1d2153b72567f0ef785871b5737e0954a3c as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.7.0-stretch-slim@sha256:4be769bb8d805184339e117a8f63d1d2153b72567f0ef785871b5737e0954a3c as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]