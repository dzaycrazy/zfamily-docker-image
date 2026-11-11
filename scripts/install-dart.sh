#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"; PREFIX=/opt/dart-sdk; begin "${1:-}"
if   [ "$LINE" = latest ]; then re='^[0-9]+\.[0-9]+\.[0-9]+$'
elif [[ "$LINE" == *.* ]];  then re="^${LINE_RE}\.[0-9]+$"
else re="^${LINE_RE}\.[0-9]+\.[0-9]+$"; fi
V="$(latest_tag https://github.com/dart-lang/sdk "$re")"
echo "Dart $V"
curl -fsSL "https://storage.googleapis.com/dart-archive/channels/stable/release/${V}/sdk/dartsdk-linux-${DART_ARCH}-release.zip" -o /tmp/dart.zip
unzip -q /tmp/dart.zip -d /opt && rm /tmp/dart.zip
