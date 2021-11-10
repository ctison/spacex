FROM node:17.1.0-stretch-slim@sha256:f0bbccd80c826d18594d561ddc7ecd0c3cfb0a6f2168dae421f4b600e03d4014 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:17.1.0-stretch-slim@sha256:f0bbccd80c826d18594d561ddc7ecd0c3cfb0a6f2168dae421f4b600e03d4014 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]