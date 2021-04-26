FROM node:16.0.0-stretch-slim@sha256:6913083ca9e45f0e9953a5685e631c2b00a9ed25f2f395f136daab17ba27af51 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.0.0-stretch-slim@sha256:6913083ca9e45f0e9953a5685e631c2b00a9ed25f2f395f136daab17ba27af51 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]