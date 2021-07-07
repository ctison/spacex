FROM node:16.4.1-stretch-slim@sha256:451b33683669e531f58b436adc9d12012f6ff0046b4df4ef44e953beebd0215a as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.4.1-stretch-slim@sha256:451b33683669e531f58b436adc9d12012f6ff0046b4df4ef44e953beebd0215a as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]