#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"; PREFIX=/opt/python; begin "${1:-}"
T="$(latest_tag https://github.com/python/cpython "^v${LINE_RE}\.[0-9]+$")"; V="${T#v}"
echo "Python $V"
cfg=(--prefix="$PREFIX" --with-ensurepip=install)
if ver_lt "$LINE" 3.10; then          # Python < 3.10 không chạy được với OpenSSL 3
  SSL="$PREFIX/openssl"; build_openssl 1.1.1w "$SSL"
  export CPPFLAGS="-I$SSL/include" LDFLAGS="-L$SSL/lib -Wl,-rpath,$SSL/lib"
  ver_lt "$LINE" 3.7 || cfg+=(--with-openssl="$SSL")
fi
mkdir -p /tmp/py && cd /tmp/py
curl -fsSL "https://www.python.org/ftp/python/${V}/Python-${V}.tgz" | tar -xz --strip-components=1
./configure "${cfg[@]}"          # bỏ --enable-optimizations (PGO) cho build nhanh hơn
make -j"$(nproc)" && make install
ln -sf python3 "$PREFIX/bin/python"
rm -rf /tmp/py "$PREFIX"/lib/python*/test "$PREFIX"/lib/python*/*/test
