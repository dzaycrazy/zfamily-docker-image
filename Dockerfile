FROM ghcr.io/ptero-eggs/yolks:nodejs_25

USER root

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl gnupg \
 && mkdir -p /etc/apt/keyrings \
 && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
 && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_25.x nodistro main" > /etc/apt/sources.list.d/nodesource.list \
 && apt-get update && apt-get install -y --no-install-recommends nodejs

RUN apt-get install -y --no-install-recommends \
      build-essential gcc g++ make \
      default-jdk-headless \
      ruby php-cli perl lua5.4 \
      bubblewrap git unzip wget \
      zlib1g-dev libssl-dev libffi-dev libbz2-dev libreadline-dev \
      libsqlite3-dev liblzma-dev libncursesw5-dev tk-dev \
 && npm install -g typescript ts-node

# ---- Ngôn ngữ bổ sung (apt): Clang, Fortran, R, Haskell, Elixir/Erlang ----
RUN apt-get install -y --no-install-recommends \
      clang gfortran \
      r-base-core \
      ghc \
      elixir

ARG PYTHON_VERSION=3.14.8
RUN cd /usr/src \
 && wget -q https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
 && tar xzf Python-${PYTHON_VERSION}.tgz && cd Python-${PYTHON_VERSION} \
 && ./configure --enable-optimizations --with-ensurepip=install \
 && make -j"$(nproc)" && make altinstall \
 && cd / && rm -rf /usr/src/Python-${PYTHON_VERSION}* \
 && ln -sf /usr/local/bin/python3.14 /usr/local/bin/python3 \
 && ln -sf /usr/local/bin/pip3.14 /usr/local/bin/pip3

ENV PATH=/usr/local/go/bin:$PATH
RUN set -eux; \
    GO_VERSION="$(curl -fsSL https://go.dev/VERSION?m=text | head -n1)"; \
    curl -fsSL "https://go.dev/dl/${GO_VERSION}.linux-$(dpkg --print-architecture).tar.gz" -o /tmp/go.tgz; \
    tar -C /usr/local -xzf /tmp/go.tgz; \
    rm /tmp/go.tgz

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH
RUN curl -fsSL https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal \
 && chmod -R a+w $RUSTUP_HOME $CARGO_HOME

# ---- C# / .NET (LTS) ----
ENV DOTNET_ROOT=/usr/share/dotnet \
    DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    DOTNET_NOLOGO=1 \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 \
    PATH=$PATH:/usr/share/dotnet
RUN curl -fsSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh \
 && bash /tmp/dotnet-install.sh --channel LTS --install-dir /usr/share/dotnet \
 && rm /tmp/dotnet-install.sh

# ---- Kotlin (bản mới nhất) ----
RUN set -eux; \
    KOTLIN_VERSION="$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/JetBrains/kotlin/releases/latest | sed 's#.*/tag/v##')"; \
    curl -fsSL "https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip" -o /tmp/kotlin.zip; \
    unzip -q /tmp/kotlin.zip -d /opt; \
    ln -s /opt/kotlinc/bin/* /usr/local/bin/; \
    rm /tmp/kotlin.zip

# ---- Deno & Bun ----
RUN curl -fsSL https://deno.land/install.sh | DENO_INSTALL=/usr/local sh \
 && curl -fsSL https://bun.sh/install | BUN_INSTALL=/usr/local bash

RUN apt-get purge -y wget gnupg && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/* /root/.npm

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container
