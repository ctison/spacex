FROM node:16.5.0-stretch-slim@sha256:85bc9c3c227d838dabc357f2b7faeb1e496935e162910501b1909039a6721bfe as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:16.5.0-stretch-slim@sha256:85bc9c3c227d838dabc357f2b7faeb1e496935e162910501b1909039a6721bfe as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]