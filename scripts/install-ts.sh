#!/usr/bin/env bash
# TypeScript + ts-node theo đúng đời Node (bản mới yêu cầu Node >= 14)
set -uo pipefail
NODE_MAJOR="${1:-}"; [ -n "$NODE_MAJOR" ] || exit 0
if   [ "$NODE_MAJOR" -ge 14 ]; then npm install -g typescript ts-node
elif [ "$NODE_MAJOR" -ge 12 ]; then npm install -g typescript@4.9 ts-node@10
else npm install -g typescript@4.9
fi || echo "[cảnh báo] không cài được TypeScript cho Node $NODE_MAJOR"
exit 0
