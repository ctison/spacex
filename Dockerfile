FROM node:15.9.0-stretch-slim@sha256:3f033b7ee572c65b227eab78319a6f630f64a34d51632433ada2d310defa393c as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.9.0-stretch-slim@sha256:3f033b7ee572c65b227eab78319a6f630f64a34d51632433ada2d310defa393c as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]