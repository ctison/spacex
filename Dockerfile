FROM node:16.1.0-stretch-slim@sha256:83342ade6bcf58be9272743e85333c8dcba9b3f71c9c530dea9821990fe9f495 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.1.0-stretch-slim@sha256:83342ade6bcf58be9272743e85333c8dcba9b3f71c9c530dea9821990fe9f495 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]