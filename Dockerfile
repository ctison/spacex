FROM node:15.12.0-stretch-slim@sha256:981e0e7859da37a24d2157de77cd198f40febd9cb20a6da4e200fc00eb753c10 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.12.0-stretch-slim@sha256:981e0e7859da37a24d2157de77cd198f40febd9cb20a6da4e200fc00eb753c10 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]