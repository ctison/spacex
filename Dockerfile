FROM node:14.12.0-stretch-slim@sha256:20f238c9674feb6a857ed4759c213087847311235236e6b884d37d3a86c48c2d as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:14.12.0-stretch-slim@sha256:20f238c9674feb6a857ed4759c213087847311235236e6b884d37d3a86c48c2d as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]