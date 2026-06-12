###############################
# Stage 0: Node 22 provider   #
###############################
FROM node:22-alpine3.19 AS node


###############################
# Stage 1: Elixir build       #
###############################
FROM hexpm/elixir:1.17.3-erlang-26.2.5.14-alpine-3.19.9 AS build

ENV MIX_ENV=prod \
    LANG=C.UTF-8

RUN apk add --no-cache \
  build-base \
  git \
  curl \
  openssl \
  openssl-dev \
  ncurses-libs \
  libstdc++ \
  libgcc

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules

RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./
COPY config config

RUN mix deps.get --only $MIX_ENV && \
    mix deps.compile

COPY assets/package*.json assets/

WORKDIR /app/assets
RUN npm ci

WORKDIR /app

RUN mix assets.setup

COPY . .

RUN mix assets.deploy

RUN mix release


###############################
# Stage 2: Runtime image      #
###############################
FROM alpine:3.19.9 AS app

ENV LANG=C.UTF-8 \
    MIX_ENV=prod \
    PORT=4000 \
    PHX_SERVER=true

RUN apk add --no-cache \
  ca-certificates \
  openssl \
  ncurses-libs \
  libstdc++ \
  libgcc

WORKDIR /app

COPY --from=build /app/_build/prod/rel/anonychat ./

RUN addgroup -S anonychat && \
    adduser -S -G anonychat anonychat && \
    chown -R anonychat:anonychat /app

EXPOSE 4000

USER anonychat

CMD ["bin/anonychat", "start"]