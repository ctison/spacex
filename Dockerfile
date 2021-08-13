FROM node:16.6.2-stretch-slim@sha256:594df8312240e21f0058a27eda9c88417a81b1394625edf519e6f9388dc19df9 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.6.2-stretch-slim@sha256:594df8312240e21f0058a27eda9c88417a81b1394625edf519e6f9388dc19df9 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]