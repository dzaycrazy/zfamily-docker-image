#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"; PREFIX=/opt/rust; begin "${1:-}"
export RUSTUP_HOME=/opt/rust/rustup CARGO_HOME=/opt/rust/cargo
echo "Rust $LINE"
curl -fsSL https://sh.rustup.rs -o /tmp/rustup.sh
sh /tmp/rustup.sh -y --no-modify-path --profile minimal --default-toolchain "$LINE" \
  || sh /tmp/rustup.sh -y --no-modify-path --default-toolchain "$LINE"   # bản cổ không có profile minimal
chmod -R a+w "$RUSTUP_HOME" "$CARGO_HOME"
