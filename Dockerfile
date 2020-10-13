FROM node:14.13.1-stretch-slim@sha256:19d61ec884cc2c72aa72e2b59d2c02de5227b2a8e8fdd2174c693e8e6d9237d4 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:14.13.1-stretch-slim@sha256:19d61ec884cc2c72aa72e2b59d2c02de5227b2a8e8fdd2174c693e8e6d9237d4 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]