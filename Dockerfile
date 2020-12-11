FROM node:15.4.0-stretch-slim@sha256:ef8e7f9710a6311bb49a5dc6f4667c216785f35d6c02e927dd9cb75a95ebe171 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.4.0-stretch-slim@sha256:ef8e7f9710a6311bb49a5dc6f4667c216785f35d6c02e927dd9cb75a95ebe171 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]