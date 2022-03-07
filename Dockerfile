FROM node:17.6.0-stretch-slim@sha256:c963e46f0693d142f8d8084bb24ef6e69d80905c1da3a622845801355c6f7262 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:17.6.0-stretch-slim@sha256:c963e46f0693d142f8d8084bb24ef6e69d80905c1da3a622845801355c6f7262 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]