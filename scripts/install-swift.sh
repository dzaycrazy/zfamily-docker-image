#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"; PREFIX=/opt/swift; begin "${1:-}"
if [ "$LINE" = latest ]; then re='^swift-[0-9]+\.[0-9]+(\.[0-9]+)?-RELEASE$'; else re="^swift-${LINE_RE}(\.[0-9]+)?-RELEASE$"; fi
V="$(git ls-remote --tags --refs https://github.com/swiftlang/swift | sed 's#.*refs/tags/##' | grep -E "$re" | sed 's/^swift-//; s/-RELEASE$//' | sort -V | tail -n1)"
echo "Swift $V"
MINOR="$(echo "$V" | cut -d. -f1,2)"
if   ver_lt "$MINOR" 5.0; then OS=ubuntu1604; OSF=ubuntu16.04
elif ver_lt "$MINOR" 5.3; then OS=ubuntu1804; OSF=ubuntu18.04
elif ver_lt "$MINOR" 5.7; then OS=ubuntu2004; OSF=ubuntu20.04
else OS=ubuntu2204; OSF=ubuntu22.04; fi
if [ "$UNAME_ARCH" = aarch64 ]; then OS="$OS-aarch64"; OSF="$OSF-aarch64"; fi
curl -fsSL "https://download.swift.org/swift-${V}-release/${OS}/swift-${V}-RELEASE/swift-${V}-RELEASE-${OSF}.tar.gz" | tar -xz -C "$PREFIX" --strip-components=1
