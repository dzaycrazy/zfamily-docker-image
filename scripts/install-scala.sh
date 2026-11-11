#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"; PREFIX=/opt/scala; begin "${1:-}"
if [[ "$LINE" == 2.* ]]; then
  V="$(latest_tag https://github.com/scala/scala "^v${LINE_RE}\.[0-9]+$")"; V="${V#v}"
  echo "Scala $V"
  for url in "https://downloads.lightbend.com/scala/${V}/scala-${V}.tgz" \
             "https://github.com/scala/scala/releases/download/v${V}/scala-${V}.tgz"; do
    curl -fsSL "$url" -o /tmp/scala.tgz && break
  done
  tar -xzf /tmp/scala.tgz -C "$PREFIX" --strip-components=1
else
  if [ "$LINE" = latest ]; then re='^[0-9]+\.[0-9]+\.[0-9]+$'; else re="^${LINE_RE}\.[0-9]+$"; fi
  V="$(latest_tag https://github.com/scala/scala3 "$re")"
  echo "Scala $V"
  curl -fsSL "https://github.com/scala/scala3/releases/download/${V}/scala3-${V}.tar.gz" | tar -xz -C "$PREFIX" --strip-components=1
fi
rm -f /tmp/scala.tgz
