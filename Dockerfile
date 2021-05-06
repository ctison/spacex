FROM node:16.1.0-stretch-slim@sha256:3c41361e12dad954e1c246d7d4b61f92eb441d310e5af17984b05ce619362032 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.1.0-stretch-slim@sha256:3c41361e12dad954e1c246d7d4b61f92eb441d310e5af17984b05ce619362032 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]