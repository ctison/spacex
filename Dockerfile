FROM node:17.0.1-stretch-slim@sha256:900407b5571ad26da5938516229b909d4d99bfbf3514ac26b03f1a942f7445b0 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:17.0.1-stretch-slim@sha256:900407b5571ad26da5938516229b909d4d99bfbf3514ac26b03f1a942f7445b0 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]