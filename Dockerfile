FROM node:15.1.0-stretch-slim@sha256:c32ea2399cee8502278fc7d6cc8819a721da4a4ca295c2f6431378615497368c as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.1.0-stretch-slim@sha256:c32ea2399cee8502278fc7d6cc8819a721da4a4ca295c2f6431378615497368c as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]