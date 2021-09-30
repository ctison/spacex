FROM node:16.10.0-stretch-slim@sha256:a35df5e6d2d5d8243bff36adba6f7d0f19a682f2cfe90ac35049e103820e67dc as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.10.0-stretch-slim@sha256:a35df5e6d2d5d8243bff36adba6f7d0f19a682f2cfe90ac35049e103820e67dc as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]