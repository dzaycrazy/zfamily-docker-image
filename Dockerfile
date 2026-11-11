# syntax=docker/dockerfile:1
# Mỗi tag (1.0 → 14.5) = một bộ version ngôn ngữ khác nhau, lấy từ versions.json.
# Mỗi ngôn ngữ build ở một stage riêng; version rỗng = tag đó không có ngôn ngữ ấy.
# BASE chọn hệ điều hành nền: ghcr.io/ptero-eggs/yolks:debian (mặc định) hoặc ubuntu:24.04 (bản -ubuntu).
# Cả hai đều là họ Debian nên dùng chung apt và cùng các script cài đặt.
ARG BASE=ghcr.io/ptero-eggs/yolks:debian

# ---------- stage nền để biên dịch ----------
FROM ${BASE} AS build-base
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git build-essential pkg-config xz-utils bzip2 unzip wget perl \
      autoconf bison re2c \
      zlib1g-dev libssl-dev libffi-dev libbz2-dev libreadline-dev libsqlite3-dev \
      liblzma-dev libncursesw5-dev tk-dev uuid-dev libgdbm-dev libyaml-dev \
      libxml2-dev libcurl4-openssl-dev libonig-dev \
 && rm -rf /var/lib/apt/lists/*

# ---------- mỗi ngôn ngữ một stage ----------
FROM build-base AS node
ARG NODE=""
RUN --mount=type=bind,source=scripts,target=/scripts bash /scripts/install-node.sh "${NODE}"

FROM build-base AS python
ARG PYTHON=""
RUN --mount=type=bind,source=scripts,target=/scripts bash /scripts/install-python.sh "${PYTHON}"

FROM build-base AS php
ARG PHP=""
RUN --mount=type=bind,source=scripts,target=/scripts bash /scripts/install-php.sh "${PHP}"

FROM build-base AS ruby
ARG RUBY=""
RUN --mount=type=bind,source=scripts,target=/scripts bash /scripts/install-ruby.sh "${RUBY}"

FROM build-base AS go
ARG GO=""
RUN --mount=type=bind,source=scripts,target=/scripts bash /scripts/install-go.sh "${GO}"

FROM build-base AS rust
ARG RUST=""
RUN --mount=type=bind,source=scripts,target=/scripts bash /scripts/install-rust.sh "${RUST}"

FROM build-base AS java
ARG JAVA=""
RUN --mount=type=bind,source=scripts,target=/scripts bash /scripts/install-java.sh "${JAVA}"

FROM build-base AS dotnet
ARG DOTNET=""
RUN --mount=type=bind,source=scripts,target=/scripts bash /scripts/install-dotnet.sh "${DOTNET}"

FROM build-base AS kotlin
ARG KOTLIN=""
RUN --mount=type=bind,source=scripts,target=/scripts bash /scripts/install-kotlin.sh "${KOTLIN}"

FROM build-base AS deno
ARG DENO=""
RUN --mount=type=bind,source=scripts,target=/scripts bash /scripts/install-deno.sh "${DENO}"

FROM build-base AS bun
ARG BUN=""
RUN --mount=type=bind,source=scripts,target=/scripts bash /scripts/install-bun.sh "${BUN}"

FROM build-base AS swift
ARG SWIFT=""
RUN --mount=type=bind,source=scripts,target=/scripts bash /scripts/install-swift.sh "${SWIFT}"

FROM build-base AS dart
ARG DART=""
RUN --mount=type=bind,source=scripts,target=/scripts bash /scripts/install-dart.sh "${DART}"

FROM build-base AS scala
ARG SCALA=""
RUN --mount=type=bind,source=scripts,target=/scripts bash /scripts/install-scala.sh "${SCALA}"

FROM build-base AS julia
ARG JULIA=""
RUN --mount=type=bind,source=scripts,target=/scripts bash /scripts/install-julia.sh "${JULIA}"

FROM build-base AS zig
ARG ZIG=""
RUN --mount=type=bind,source=scripts,target=/scripts bash /scripts/install-zig.sh "${ZIG}"

# ---------- image cuối ----------
FROM ${BASE}
USER root

# Công cụ chung + ngôn ngữ lấy theo bản Debian của base (Perl, Lua, R, Haskell, Elixir, Clang, Fortran)
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git unzip wget bubblewrap \
      build-essential gcc g++ make clang gfortran \
      perl lua5.4 r-base-core ghc elixir \
      zlib1g-dev libssl-dev libffi-dev libbz2-dev libreadline-dev libsqlite3-dev \
      liblzma-dev libncursesw5-dev tk-dev libxml2-dev libyaml-dev libonig-dev libgdbm-dev \
 && rm -rf /var/lib/apt/lists/*

COPY --from=node   /opt/node    /opt/node
COPY --from=python /opt/python  /opt/python
COPY --from=php    /opt/php     /opt/php
COPY --from=ruby   /opt/ruby    /opt/ruby
COPY --from=go     /opt/go      /opt/go
COPY --from=rust   /opt/rust    /opt/rust
COPY --from=java   /opt/java    /opt/java
COPY --from=dotnet /opt/dotnet  /opt/dotnet
COPY --from=kotlin /opt/kotlinc /opt/kotlinc
COPY --from=deno   /opt/deno    /opt/deno
COPY --from=bun    /opt/bun     /opt/bun
COPY --from=swift  /opt/swift   /opt/swift
COPY --from=dart   /opt/dart-sdk /opt/dart-sdk
COPY --from=scala  /opt/scala   /opt/scala
COPY --from=julia  /opt/julia   /opt/julia
COPY --from=zig    /opt/zig     /opt/zig

ENV JAVA_HOME=/opt/java \
    RUSTUP_HOME=/opt/rust/rustup \
    CARGO_HOME=/opt/rust/cargo \
    DOTNET_ROOT=/opt/dotnet \
    DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    DOTNET_NOLOGO=1 \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 \
    PATH=/opt/node/bin:/opt/python/bin:/opt/php/bin:/opt/ruby/bin:/opt/go/bin:/opt/java/bin:/opt/rust/cargo/bin:/opt/dotnet:/opt/kotlinc/bin:/opt/deno/bin:/opt/bun/bin:/opt/swift/usr/bin:/opt/dart-sdk/bin:/opt/scala/bin:/opt/julia/bin:/opt/zig:$PATH

# Ngôn ngữ phổ biến lấy từ apt (theo bản Debian của base). Gói nào không có thì bỏ qua, không làm hỏng build.
RUN apt-get update \
 && for p in ocaml-nox fp-compiler sbcl nasm gobjc gnucobol4 gnucobol sqlite3 \
             libedit2 libcurl4 tzdata; do \
      apt-get install -y --no-install-recommends "$p" || echo "[bỏ qua] $p"; \
    done \
 && rm -rf /var/lib/apt/lists/*

ARG NODE=""
RUN --mount=type=bind,source=scripts,target=/scripts bash /scripts/install-ts.sh "${NODE}"

# Ngôn ngữ cài thêm từ apt (không theo tag). Gói nào không có trong bản Debian của base thì bỏ qua.
# mingw-w64 = biên dịch chéo ra file .exe của Windows (gcc/g++ cho Windows).
# (Erlang đã có sẵn nhờ Elixir; F# và Visual Basic đã có trong .NET SDK; Obj-C có trong gobjc.)
RUN apt-get update \
 && for p in gawk tcl swi-prolog guile-3.0 racket clisp ecl gforth gnu-smalltalk \
             gnat ldc gdc nim crystal haxe rakudo vala luajit yasm tcc \
             iverilog ghdl gnu-apl octave groovy clojure protobuf-compiler \
             zsh fish pypy3 mingw-w64 \
             gprolog ats2-lang chicken-bin gambc mit-scheme postgresql-client mariadb-client \
             xz-utils bzip2 llvm libgc-dev libevent-dev libpcre2-dev \
             libx11-6 libxcursor1 libxinerama1 libxi6 libxrandr2 libgl1 libfontconfig1 \
             libasound2t64 libasound2; do \
      apt-get install -y --no-install-recommends "$p" || echo "[bỏ qua] $p"; \
    done \
 && rm -rf /var/lib/apt/lists/*

# PowerShell, Gleam, V, Crystal, Odin, Pony, Cairo, Solidity, HCL, GDScript, J, BQN, Mojo, Q#, CoffeeScript, ...
# (token GitHub là tùy chọn: có thì khỏi bị giới hạn API khi tra bản mới nhất)
RUN --mount=type=bind,source=scripts,target=/scripts \
    --mount=type=secret,id=gh_token,required=false \
    bash /scripts/install-extras.sh "${NODE}"

# Base yolks đã có user "container"; base Ubuntu thì chưa nên tạo (Pterodactyl cần user này).
RUN id container >/dev/null 2>&1 || useradd -m -d /home/container -s /bin/bash container

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container
