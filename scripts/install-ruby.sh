#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"; PREFIX=/opt/ruby; begin "${1:-}"
V="$(curl -fsSL https://cache.ruby-lang.org/pub/ruby/index.txt | awk -v re="^ruby-${LINE_RE}\\.[0-9]+$" '$1 ~ re {print $1}' | sort -V | tail -n1)"; V="${V#ruby-}"
echo "Ruby $V"
cfg=(--prefix="$PREFIX" --disable-install-doc)
if ver_lt "$LINE" 3.1; then            # Ruby < 3.1 không chạy được với OpenSSL 3
  SSL="$PREFIX/openssl"
  if ver_lt "$LINE" 2.4; then build_openssl 1.0.2u "$SSL"; else build_openssl 1.1.1w "$SSL"; fi
  cfg+=(--with-openssl-dir="$SSL"); export LDFLAGS="-Wl,-rpath,$SSL/lib"
fi
mkdir -p /tmp/rb && cd /tmp/rb
curl -fsSL "https://cache.ruby-lang.org/pub/ruby/${LINE}/ruby-${V}.tar.xz" | tar -xJ --strip-components=1
./configure "${cfg[@]}"
make -j"$(nproc)" && make install
rm -rf /tmp/rb
