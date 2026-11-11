#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"; PREFIX=/opt/java; begin "${1:-}"
echo "Java (Temurin) $LINE"
curl -fsSL "https://api.adoptium.net/v3/binary/latest/${LINE}/ga/linux/${JAVA_ARCH}/jdk/hotspot/normal/eclipse" | tar -xz -C "$PREFIX" --strip-components=1
