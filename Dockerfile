FROM node:16.5.0-stretch-slim@sha256:6201b7c42563f572133da407324f74a0f3f839a6b7ecb3eb22cd0b096463e347 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.5.0-stretch-slim@sha256:6201b7c42563f572133da407324f74a0f3f839a6b7ecb3eb22cd0b096463e347 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]