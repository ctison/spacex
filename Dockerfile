FROM node:14.10.1-stretch-slim@sha256:6f5829f9a226e25d8907429b6046bc6ee3f1210e30557551ef70ccb4b4d69350 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:14.10.1-stretch-slim@sha256:6f5829f9a226e25d8907429b6046bc6ee3f1210e30557551ef70ccb4b4d69350 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]