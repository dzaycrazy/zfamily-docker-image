#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"; PREFIX=/opt/bun; begin "${1:-}"
if [ "$LINE" = latest ]; then re='^bun-v[0-9]+\.[0-9]+\.[0-9]+$'; else re="^bun-v${LINE_RE}\.[0-9]+$"; fi
T="$(latest_tag https://github.com/oven-sh/bun "$re")"
echo "Bun $T"
curl -fsSL https://bun.sh/install | BUN_INSTALL="$PREFIX" bash -s "$T"
