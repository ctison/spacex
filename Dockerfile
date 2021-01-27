FROM node:15.6.0-stretch-slim@sha256:0241181df2c9b398d2261331d1ad29f98cf965b155df5daa39d011b935457fb4 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.6.0-stretch-slim@sha256:0241181df2c9b398d2261331d1ad29f98cf965b155df5daa39d011b935457fb4 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]