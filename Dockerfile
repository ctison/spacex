FROM node:15.2.1-stretch-slim@sha256:b677635aa373fd242ce103243aebb0f2e99892e347ea15a4010706768e247ccc as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.2.1-stretch-slim@sha256:b677635aa373fd242ce103243aebb0f2e99892e347ea15a4010706768e247ccc as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]