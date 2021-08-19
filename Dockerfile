FROM node:16.7.0-stretch-slim@sha256:309bf09dadfac4c60615794fc500072d1df675cd24c772a9a619d510823a716c as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.7.0-stretch-slim@sha256:309bf09dadfac4c60615794fc500072d1df675cd24c772a9a619d510823a716c as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]