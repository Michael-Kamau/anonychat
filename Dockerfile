###############################
# Stage 0: Node 22 provider   #
###############################
FROM node:22-alpine AS node

# We don't need to do anything here; we'll just copy node + npm out of it


###############################
# Stage 1: Elixir build       #
###############################
FROM elixir:1.15-alpine AS build

ENV MIX_ENV=prod \
    LANG=C.UTF-8

# System deps (no nodejs from apk!)
RUN apk add --no-cache \
  build-base \
  git \
  curl

# Copy Node 22 + npm from the node:22-alpine image
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
# Make npm available on PATH
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

WORKDIR /app

# Hex & Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy mix + config
COPY mix.exs mix.lock ./
COPY config config

# Fetch & compile deps
RUN mix deps.get --only $MIX_ENV && \
    mix deps.compile

# Install JS deps for Vite/Vue/Inertia
COPY assets/package*.json assets/
WORKDIR /app/assets
RUN npm install

WORKDIR /app

# Install esbuild/tailwind binaries (you still need tailwind)
RUN mix assets.setup

# Copy the rest of the project
COPY . .

# IMPORTANT: your aliases should now have *no esbuild* in assets.deploy:
# "assets.deploy": [
#   "tailwind anonychat --minify",
#   "cmd --cd assets node node_modules/vite/bin/vite.js build",
#   "phx.digest"
# ]
RUN mix assets.deploy

# Build the release
RUN mix release


###############################
# Stage 2: Runtime image      #
###############################
FROM alpine:3.18 AS app

ENV LANG=C.UTF-8 \
    MIX_ENV=prod \
    PORT=4000 \
    PHX_SERVER=true

RUN apk add --no-cache \
  openssl \
  ncurses-libs \
  libstdc++

WORKDIR /app

COPY --from=build /app/_build/prod/rel/anonychat ./

EXPOSE 4000

CMD ["bin/anonychat", "start"]
