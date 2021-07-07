FROM node:16.4.0-stretch-slim@sha256:350b89f58a40081532c5183f25f1ecb6490cf060423a99570405b0535fc8894e as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.4.0-stretch-slim@sha256:350b89f58a40081532c5183f25f1ecb6490cf060423a99570405b0535fc8894e as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]