FROM node:16.6.1-stretch-slim@sha256:9deac1dd5ca9f72ef4d851844660e9c54149635efe3b0c665857c90774f8625c as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.6.1-stretch-slim@sha256:9deac1dd5ca9f72ef4d851844660e9c54149635efe3b0c665857c90774f8625c as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]