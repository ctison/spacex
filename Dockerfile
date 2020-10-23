FROM node:15.0.1-stretch-slim@sha256:5c50d3a17c545be0cc40d2b32b89e2118ab9e956f234186f1e01200e74e5e009 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.0.1-stretch-slim@sha256:5c50d3a17c545be0cc40d2b32b89e2118ab9e956f234186f1e01200e74e5e009 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]