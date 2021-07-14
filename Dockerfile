FROM node:16.5.0-stretch-slim@sha256:4ec570acd9e3b55ee880bc602d4d018c9175b3e7cad477867d80d704f4c108f2 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.5.0-stretch-slim@sha256:4ec570acd9e3b55ee880bc602d4d018c9175b3e7cad477867d80d704f4c108f2 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]