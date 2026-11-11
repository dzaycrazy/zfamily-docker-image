#!/usr/bin/env bash
# Hàm dùng chung cho các script cài ngôn ngữ.
set -euo pipefail

case "$(dpkg --print-architecture)" in
  amd64) NODE_ARCH=x64;   GO_ARCH=amd64; JAVA_ARCH=x64 ;;
  arm64) NODE_ARCH=arm64; GO_ARCH=arm64; JAVA_ARCH=aarch64 ;;
  *) echo "Kiến trúc CPU chưa hỗ trợ" >&2; exit 1 ;;
esac

# Gọi đầu mỗi script: tạo thư mục cài và thoát êm nếu version rỗng (= tag này không có ngôn ngữ đó)
begin() { LINE="${1:-}"; mkdir -p "$PREFIX"; [ -n "$LINE" ] || { echo "[bỏ qua] không có version"; exit 0; }; LINE_RE="${LINE//./\\.}"; }

# latest_tag <git-url> <regex>  -> tag mới nhất khớp regex
latest_tag() { git ls-remote --tags --refs "$1" | sed 's#.*refs/tags/##' | grep -E "$2" | sort -V | tail -n1; }

# ver_lt A B -> đúng nếu A < B
ver_lt() { [ "$1" != "$2" ] && [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -n1)" = "$1" ]; }

# build_openssl <version> <prefix> : OpenSSL cũ cho Python/PHP/Ruby đời cũ (Debian mới chỉ có OpenSSL 3)
build_openssl() {
  local v="$1" p="$2" series="${1%[a-z]}"   # 1.1.1w -> thư mục 1.1.1
  mkdir -p /tmp/ssl && cd /tmp/ssl
  curl -fsSL "https://www.openssl.org/source/old/${series}/openssl-${v}.tar.gz" | tar -xz --strip-components=1
  ./config --prefix="$p" --openssldir="$p/ssl" shared no-tests
  case "$v" in 1.0.*) make ;; *) make -j"$(nproc)" ;; esac
  make install_sw install_ssldirs
  rm -rf "$p/ssl/certs" && ln -s /etc/ssl/certs "$p/ssl/certs"
  cd / && rm -rf /tmp/ssl
}

# Kiến trúc cho các nhà phát hành khác nhau
case "$(dpkg --print-architecture)" in
  amd64) UNAME_ARCH=x86_64;  DART_ARCH=x64;   JULIA_DIR=x64 ;;
  arm64) UNAME_ARCH=aarch64; DART_ARCH=arm64; JULIA_DIR=aarch64 ;;
esac
