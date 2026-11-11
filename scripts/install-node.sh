#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"; PREFIX=/opt/node; begin "${1:-}"
V="$(curl -fsSL https://nodejs.org/dist/index.json | grep -o "\"version\":\"v${LINE_RE}\.[0-9.]*\"" | head -n1 | cut -d'"' -f4)"
echo "Node.js $V"
curl -fsSL "https://nodejs.org/dist/${V}/node-${V}-linux-${NODE_ARCH}.tar.xz" | tar -xJ -C "$PREFIX" --strip-components=1
