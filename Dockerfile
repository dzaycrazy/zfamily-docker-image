# Image đa ngôn ngữ cho egg Node.js (Pterodactyl/Altare/Pelican). Giữ nguyên ENTRYPOINT/CMD/USER của image gốc để egg chạy được startup.
FROM ghcr.io/pterodactyl/yolks:nodejs_20

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
      python3 python3-pip python3-venv \
      gcc g++ make \
      golang-go \
      default-jdk-headless \
      ruby php-cli perl lua5.4 \
      rustc cargo \
      bubblewrap git curl ca-certificates unzip \
 && npm install -g typescript ts-node \
 && rm -rf /var/lib/apt/lists/* /root/.npm

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container
