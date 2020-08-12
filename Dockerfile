FROM node:14.8.0-stretch-slim@sha256:b78cc0108a2790efecbe43dfd2e9a8c63cd08d3b7cbef42776032a5ffec50ab1 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:14.8.0-stretch-slim@sha256:b78cc0108a2790efecbe43dfd2e9a8c63cd08d3b7cbef42776032a5ffec50ab1 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]