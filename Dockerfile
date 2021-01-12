FROM node:15.5.1-stretch-slim@sha256:744facce6d75bd6c05d6d771c3eec07f453e1f3a6b15660a18b97be213e43858 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.5.1-stretch-slim@sha256:744facce6d75bd6c05d6d771c3eec07f453e1f3a6b15660a18b97be213e43858 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]