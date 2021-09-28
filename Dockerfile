FROM node:16.10.0-stretch-slim@sha256:e49430e9122618a06ecade78dd06f534e21d2275ff5d5d0ae49a11fa37e4ffa9 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.10.0-stretch-slim@sha256:e49430e9122618a06ecade78dd06f534e21d2275ff5d5d0ae49a11fa37e4ffa9 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]