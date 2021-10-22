FROM node:17.0.1-stretch-slim@sha256:332644bf6a6a4d24fa53cacb3d6cf670430d782e7c6a098e8415d7cbdc7da4a5 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:17.0.1-stretch-slim@sha256:332644bf6a6a4d24fa53cacb3d6cf670430d782e7c6a098e8415d7cbdc7da4a5 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]