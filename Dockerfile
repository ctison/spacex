FROM node:16.6.2-stretch-slim@sha256:ec41d07b57a7b9c0755feee388cda53c34b3e3cfce840ad96897fd1091498690 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.6.2-stretch-slim@sha256:ec41d07b57a7b9c0755feee388cda53c34b3e3cfce840ad96897fd1091498690 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]