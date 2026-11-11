#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"; PREFIX=/opt/kotlinc; begin "${1:-}"
if [ "$LINE" = latest ]; then re='^v[0-9]+\.[0-9]+\.[0-9]+$'; else re="^v${LINE_RE}\.[0-9]+$"; fi
T="$(latest_tag https://github.com/JetBrains/kotlin "$re")"
echo "Kotlin $T"
curl -fsSL "https://github.com/JetBrains/kotlin/releases/download/${T}/kotlin-compiler-${T#v}.zip" -o /tmp/kotlin.zip
unzip -q /tmp/kotlin.zip -d /opt && rm /tmp/kotlin.zip
