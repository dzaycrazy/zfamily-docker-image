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

RUN apt-get purge -y wget gnupg && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/* /root/.npm

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container
