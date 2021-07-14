FROM node:16.5.0-stretch-slim@sha256:4d69a1481e589505803cedc8e75adc4ff71dc6dee8b86944d1d24229a17228ea as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.5.0-stretch-slim@sha256:4d69a1481e589505803cedc8e75adc4ff71dc6dee8b86944d1d24229a17228ea as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]