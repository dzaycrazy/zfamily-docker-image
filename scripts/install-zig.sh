#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"; PREFIX=/opt/zig; begin "${1:-}"
if [ "$LINE" = latest ]; then re='^[0-9]+\.[0-9]+\.[0-9]+$'; else re="^${LINE_RE}\.[0-9]+$"; fi
V="$(latest_tag https://github.com/ziglang/zig "$re")"
echo "Zig $V"
if ver_lt "$V" 0.14.0; then NAME="zig-linux-${UNAME_ARCH}-${V}"; else NAME="zig-${UNAME_ARCH}-linux-${V}"; fi
curl -fsSL "https://ziglang.org/download/${V}/${NAME}.tar.xz" | tar -xJ -C "$PREFIX" --strip-components=1
