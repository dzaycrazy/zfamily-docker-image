#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"; PREFIX=/opt/julia; begin "${1:-}"
if [ "$LINE" = latest ]; then re='^v[0-9]+\.[0-9]+\.[0-9]+$'; else re="^v${LINE_RE}\.[0-9]+$"; fi
T="$(latest_tag https://github.com/JuliaLang/julia "$re")"; V="${T#v}"
echo "Julia $V"
curl -fsSL "https://julialang-s3.julialang.org/bin/linux/${JULIA_DIR}/${V%.*}/julia-${V}-linux-${UNAME_ARCH}.tar.gz" | tar -xz -C "$PREFIX" --strip-components=1
