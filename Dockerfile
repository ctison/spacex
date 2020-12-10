FROM node:15.4.0-stretch-slim@sha256:24467e2d48758332503eecb58aedebda6967141a8828c477e739f7b4185ff411 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.4.0-stretch-slim@sha256:24467e2d48758332503eecb58aedebda6967141a8828c477e739f7b4185ff411 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]