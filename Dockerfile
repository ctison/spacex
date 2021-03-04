FROM node:15.11.0-stretch-slim@sha256:e298a78602dc5362c228f5806b9b5b70f5fd97e4b1ecd074de1913e15d7aa07a as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.11.0-stretch-slim@sha256:e298a78602dc5362c228f5806b9b5b70f5fd97e4b1ecd074de1913e15d7aa07a as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]