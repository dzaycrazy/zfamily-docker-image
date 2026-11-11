#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"; PREFIX=/opt/dotnet; begin "${1:-}"
echo ".NET $LINE"
curl -fsSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh
bash /tmp/dotnet-install.sh --channel "$LINE" --install-dir "$PREFIX"
