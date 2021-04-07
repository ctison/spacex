FROM node:15.14.0-stretch-slim@sha256:cf719b2348a54b1c44404496bae0062bfc04a429664f4dd580312649d650867f as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.14.0-stretch-slim@sha256:cf719b2348a54b1c44404496bae0062bfc04a429664f4dd580312649d650867f as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]