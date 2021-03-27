FROM node:15.12.0-stretch-slim@sha256:6162cc6e2020513fd85f72dc074d1d190690292a128764e4b8d541b8bde4c24a as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.12.0-stretch-slim@sha256:6162cc6e2020513fd85f72dc074d1d190690292a128764e4b8d541b8bde4c24a as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]