FROM node:16.7.0-stretch-slim@sha256:38e1c0b7fe64f30c2d19998a71ae4302ed4a7fa6ab352ce1c75fb07c6ec61d56 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.7.0-stretch-slim@sha256:38e1c0b7fe64f30c2d19998a71ae4302ed4a7fa6ab352ce1c75fb07c6ec61d56 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]