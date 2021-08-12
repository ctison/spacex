FROM node:16.6.2-stretch-slim@sha256:d2a9522bb1047b3c86c96deb2d4166af8b4b027cf60109c093c576a46e01a31b as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.6.2-stretch-slim@sha256:d2a9522bb1047b3c86c96deb2d4166af8b4b027cf60109c093c576a46e01a31b as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]