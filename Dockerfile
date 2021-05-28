FROM node:16.2.0-stretch-slim@sha256:17894b3080b2c2c52e824f10eb0a704a324300b6cc51b6fb61afd97e7aa8fcf3 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.2.0-stretch-slim@sha256:17894b3080b2c2c52e824f10eb0a704a324300b6cc51b6fb61afd97e7aa8fcf3 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]