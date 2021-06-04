FROM node:16.3.0-stretch-slim@sha256:1eecc8095402a6c21ead507aca5424e5404e691d01a01dcebcc509cadf721430 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.3.0-stretch-slim@sha256:1eecc8095402a6c21ead507aca5424e5404e691d01a01dcebcc509cadf721430 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]