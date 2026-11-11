#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"; PREFIX=/opt/go; begin "${1:-}"
if [ "$LINE" = latest ]; then
  V="$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -n1)"
else
  V="$(curl -fsSL 'https://go.dev/dl/?mode=json&include=all' | grep -oE "\"version\": *\"go${LINE_RE}(\.[0-9]+)?\"" | grep -oE 'go[0-9.]+' | sort -V | tail -n1)"
fi
echo "Go $V"
curl -fsSL "https://go.dev/dl/${V}.linux-${GO_ARCH}.tar.gz" | tar -xz -C /opt
