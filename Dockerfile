FROM node:16.6.2-stretch-slim@sha256:09a06d0fc38d72f0dbbbe8d91a536b7ffe7f1da01f8a9655ef14079987fa0dfb as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.6.2-stretch-slim@sha256:09a06d0fc38d72f0dbbbe8d91a536b7ffe7f1da01f8a9655ef14079987fa0dfb as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]