FROM node:15.13.0-stretch-slim@sha256:6ff8e92a2fc67e77927f7768eef6047ef69043005d1dc285e88b58da6c4d6a44 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.13.0-stretch-slim@sha256:6ff8e92a2fc67e77927f7768eef6047ef69043005d1dc285e88b58da6c4d6a44 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]