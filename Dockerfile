###############################
# Stage 0: Node 22 provider   #
###############################
FROM node:22-alpine3.20 AS node


###############################
# Stage 1: Elixir build       #
###############################
FROM elixir:1.17-otp-26-alpine AS build

ENV MIX_ENV=prod \
    LANG=C.UTF-8

# System deps
RUN apk add --no-cache \
  build-base \
  git \
  curl \
  openssl \
  ncurses-libs \
  libstdc++ \
  libgcc

# Copy Node 22 + npm from the node image
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules

# Make npm available on PATH
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

WORKDIR /app

# Hex & Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy mix + config first for better Docker caching
COPY mix.exs mix.lock ./
COPY config config

# Fetch & compile deps
RUN mix deps.get --only $MIX_ENV && \
    mix deps.compile

# Install JS deps for Vite/Vue/Inertia
COPY assets/package*.json assets/

WORKDIR /app/assets

RUN npm ci

WORKDIR /app

# Install esbuild/tailwind binaries if your Phoenix aliases need them
RUN mix assets.setup

# Copy the rest of the project
COPY . .

# Build frontend assets
RUN mix assets.deploy

# Build the release
RUN mix release


###############################
# Stage 2: Runtime image      #
###############################
FROM alpine:3.20 AS app

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