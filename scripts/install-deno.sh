#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"; PREFIX=/opt/deno; begin "${1:-}"
if [ "$LINE" = latest ]; then re='^v[0-9]+\.[0-9]+\.[0-9]+$'; else re="^v${LINE_RE}\.[0-9]+\.[0-9]+$"; fi
T="$(latest_tag https://github.com/denoland/deno "$re")"
echo "Deno $T"
curl -fsSL https://deno.land/install.sh | DENO_INSTALL="$PREFIX" sh -s "$T"
