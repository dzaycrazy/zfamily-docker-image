#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"; PREFIX=/opt/php; begin "${1:-}"
T="$(latest_tag https://github.com/php/php-src "^php-${LINE_RE}\.[0-9]+$")"; V="${T#php-}"
echo "PHP $V"
mkdir -p /tmp/php && cd /tmp/php
got=0
for url in "https://www.php.net/distributions/php-$V.tar.xz" \
           "https://museum.php.net/php7/php-$V.tar.xz" \
           "https://museum.php.net/php5/php-$V.tar.xz"; do
  if curl -fsSL "$url" -o src.tar.xz; then tar -xJf src.tar.xz --strip-components=1; got=1; break; fi
done
if [ "$got" = 0 ]; then   # dự phòng: lấy từ GitHub rồi tự sinh configure
  curl -fsSL "https://github.com/php/php-src/archive/refs/tags/php-$V.tar.gz" | tar -xz --strip-components=1
  ./buildconf --force
fi
cfg=(--prefix="$PREFIX" --without-pear --enable-mbstring --with-zlib --enable-sockets --enable-pcntl --enable-bcmath)
if ver_lt "$LINE" 8.1; then            # PHP < 8.1 không build được với OpenSSL 3
  SSL="$PREFIX/openssl"
  if [ "$LINE" = 7.0 ]; then build_openssl 1.0.2u "$SSL"; else build_openssl 1.1.1w "$SSL"; fi
  export LDFLAGS="-L$SSL/lib -Wl,-rpath,$SSL/lib" CPPFLAGS="-I$SSL/include"
  if ver_lt "$LINE" 7.4; then cfg+=(--with-openssl="$SSL"); else export PKG_CONFIG_PATH="$SSL/lib/pkgconfig"; cfg+=(--with-openssl); fi
  # không bật curl ở bản cũ: libcurl của Debian dùng OpenSSL 3, đụng với OpenSSL cũ trong cùng một tiến trình
else
  cfg+=(--with-openssl --with-curl)
fi
./configure "${cfg[@]}"
make -j"$(nproc)" && make install
rm -rf /tmp/php
