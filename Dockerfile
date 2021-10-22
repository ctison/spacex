FROM node:17.0.1-stretch-slim@sha256:ae3365e00cb4e395057e913a293d0ea02660c658057d481f0422c589c59ba08b as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:17.0.1-stretch-slim@sha256:ae3365e00cb4e395057e913a293d0ea02660c658057d481f0422c589c59ba08b as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]