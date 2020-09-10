FROM node:14.10.0-stretch-slim@sha256:2be0b0ff8fdf14453b43f8f10234d05c718fd7b6947e080982f5e57ed4c595f0 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:14.10.0-stretch-slim@sha256:2be0b0ff8fdf14453b43f8f10234d05c718fd7b6947e080982f5e57ed4c595f0 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]