FROM node:16.6.0-stretch-slim@sha256:cf9bdace441a57befb1e9b274bc2e77872f1ede3246e22c457809f641cf8d9ce as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.6.0-stretch-slim@sha256:cf9bdace441a57befb1e9b274bc2e77872f1ede3246e22c457809f641cf8d9ce as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]