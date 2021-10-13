FROM node:16.11.1-stretch-slim@sha256:855647cde112522975266be57154f269b1117c9d19aff876b2b4c141ad8a8215 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.11.1-stretch-slim@sha256:855647cde112522975266be57154f269b1117c9d19aff876b2b4c141ad8a8215 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]