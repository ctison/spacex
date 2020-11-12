FROM node:15.2.0-stretch-slim@sha256:5e0a06c53061bdc2c801a006bbe085119aee0057f9a9bfd1bb17e10d7c5fd6f0 as base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . ./

FROM base as build
RUN yarn install
RUN yarn run format
RUN yarn run lint
RUN yarn run build

FROM node:15.2.0-stretch-slim@sha256:5e0a06c53061bdc2c801a006bbe085119aee0057f9a9bfd1bb17e10d7c5fd6f0 as prod
WORKDIR /app
COPY --from=base /app/package.json ./
COPY --from=base /app/node_modules/ ./node_modules/
COPY --from=base /app/public/ ./public/
COPY --from=build /app/.next/ ./.next/
EXPOSE 3000
CMD ["yarn", "start"]