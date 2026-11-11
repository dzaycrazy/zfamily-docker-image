#!/usr/bin/env bash
# Ngôn ngữ cài thêm — KHÔNG theo tag (mọi tag đều có, trừ phần npm cần Node >= 18).
# Mọi bước đều "mềm": lỗi thì in [bỏ qua] rồi đi tiếp, không làm hỏng build.
source "$(dirname "$0")/lib.sh"
set +e
NODE_MAJOR="${1:-}"

# --- Ngôn ngữ chạy trên Node (CoffeeScript, AssemblyScript, Solidity, ReScript, PureScript, Elm) ---
if [ -n "$NODE_MAJOR" ] && [ "$NODE_MAJOR" -ge 18 ] 2>/dev/null; then
  for p in coffeescript assemblyscript solc rescript purescript elm; do
    npm install -g "$p" || echo "[bỏ qua] npm $p"
  done
else
  echo "[bỏ qua] npm extras (cần Node >= 18, tag này dùng Node '${NODE_MAJOR}')"
fi

# --- PowerShell (bản ổn định mới nhất, tự mang runtime riêng) ---
(
  set -e
  case "$(dpkg --print-architecture)" in amd64) PA=x64 ;; arm64) PA=arm64 ;; esac
  T="$(latest_tag https://github.com/PowerShell/PowerShell '^v[0-9]+\.[0-9]+\.[0-9]+$')"; V="${T#v}"
  echo "PowerShell $V"
  mkdir -p /opt/powershell
  curl -fsSL "https://github.com/PowerShell/PowerShell/releases/download/${T}/powershell-${V}-linux-${PA}.tar.gz" \
    | tar -xz -C /opt/powershell
  chmod +x /opt/powershell/pwsh && ln -sf /opt/powershell/pwsh /usr/local/bin/pwsh
) || echo "[bỏ qua] PowerShell"

# --- Gleam (chạy trên Erlang, đã có sẵn nhờ Elixir) ---
(
  set -e
  T="$(latest_tag https://github.com/gleam-lang/gleam '^v[0-9]+\.[0-9]+\.[0-9]+$')"
  echo "Gleam ${T#v}"
  curl -fsSL "https://github.com/gleam-lang/gleam/releases/download/${T}/gleam-${T}-${UNAME_ARCH}-unknown-linux-musl.tar.gz" \
    | tar -xz -C /usr/local/bin gleam
) || echo "[bỏ qua] Gleam"


# =====================================================================
# Phần 2: nhiều ngôn ngữ hơn (tải từ GitHub release / pip / build từ nguồn)
# Mỗi ngôn ngữ chạy trong subshell riêng; lỗi thì in [bỏ qua] rồi đi tiếp.
# =====================================================================
case "$(dpkg --print-architecture)" in
  amd64) DEB=amd64; PONY=x86-64; VASSET='/v_linux\.zip$';       GODOT=x86_64 ;;
  arm64) DEB=arm64; PONY=arm64;  VASSET='/v_linux_arm64\.zip$'; GODOT=arm64  ;;
esac

# Token GitHub (nếu workflow truyền vào) để khỏi bị giới hạn API
GH_AUTH=()
[ -s /run/secrets/gh_token ] && GH_AUTH=(-H "Authorization: Bearer $(cat /run/secrets/gh_token)")

# gh_asset <owner/repo> <regex> -> link tải của release mới nhất có tên khớp regex
gh_asset() {
  curl -fsSL "${GH_AUTH[@]}" "https://api.github.com/repos/$1/releases/latest" \
    | grep -o '"browser_download_url": *"[^"]*"' | cut -d'"' -f4 | grep -E "$2" | head -n1
}

# unpack <url> <thư mục> : tải + giải nén (.zip hoặc .tar.*); nếu chỉ có 1 thư mục con thì bỏ cấp đó
unpack() {
  local url="$1" dir="$2" f=/tmp/dl.$$ t=/tmp/unz.$$
  [ -n "$url" ] || { echo "không tìm thấy bản tải" >&2; return 1; }
  mkdir -p "$dir" "$t"; curl -fsSL "$url" -o "$f"
  case "$url" in *.zip) unzip -q "$f" -d "$t" ;; *) tar -xf "$f" -C "$t" ;; esac
  if [ "$(ls -A "$t" | wc -l)" = 1 ] && [ -d "$t/$(ls -A "$t")" ]; then cp -a "$t"/*/. "$dir"/; else cp -a "$t"/. "$dir"/; fi
  rm -rf "$f" "$t"
}

try() { local n="$1"; shift; ( set -e; "$@" ) || echo "[bỏ qua] $n"; }

inst_v()       { unpack "$(gh_asset vlang/v "$VASSET")" /opt/v; ln -sf /opt/v/v /usr/local/bin/v; }
inst_crystal() { unpack "$(gh_asset crystal-lang/crystal "crystal-[0-9.]+-[0-9]+-linux-${UNAME_ARCH}\.tar\.gz$")" /opt/crystal
                 ln -sf /opt/crystal/bin/crystal /usr/local/bin/crystal; ln -sf /opt/crystal/bin/shards /usr/local/bin/shards; }
inst_odin()    { unpack "$(gh_asset odin-lang/Odin "odin-linux-${DEB}.*\.(zip|tar\.gz)$")" /opt/odin
                 chmod +x /opt/odin/odin; ln -sf /opt/odin/odin /usr/local/bin/odin; }
inst_pony()    { unpack "$(gh_asset ponylang/ponyc "ponyc-${PONY}-unknown-linux-.*\.tar\.gz$")" /opt/ponyc
                 ln -sf /opt/ponyc/bin/ponyc /usr/local/bin/ponyc; }
inst_scarb()   { unpack "$(gh_asset software-mansion/scarb "scarb-v[0-9.]+-${UNAME_ARCH}-unknown-linux-gnu\.tar\.gz$")" /opt/scarb
                 ln -sf /opt/scarb/bin/scarb /usr/local/bin/scarb; }
inst_solc()    { [ "$DEB" = amd64 ] || { echo "solc chỉ có bản amd64"; return 1; }
                 curl -fsSL "$(gh_asset ethereum/solidity '/solc-static-linux$')" -o /usr/local/bin/solc; chmod +x /usr/local/bin/solc; }
inst_tofu()    { curl -fsSL "$(gh_asset opentofu/opentofu "tofu_[0-9.]+_linux_${GO_ARCH}\.tar\.gz$")" | tar -xz -C /usr/local/bin tofu; }
inst_godot()   { unpack "$(gh_asset godotengine/godot "Godot_v[0-9.]+-stable_linux\.${GODOT}\.zip$")" /opt/godot
                 G="$(ls /opt/godot/Godot_v* | head -n1)"; chmod +x "$G"; ln -sf "$G" /usr/local/bin/godot; }
inst_j()       { unpack "$(gh_asset jsoftware/jsource 'linux.*64.*\.tar\.gz$')" /opt/j
                 ln -sf "$(find /opt/j -name jconsole -type f | head -n1)" /usr/local/bin/jconsole; }
inst_bqn()     { git clone -q --depth 1 --recurse-submodules --shallow-submodules https://github.com/dzaima/CBQN /tmp/cbqn
                 make -C /tmp/cbqn -j"$(nproc)" && install /tmp/cbqn/BQN /usr/local/bin/bqn; rm -rf /tmp/cbqn; }
inst_pip()     { [ -x /opt/python/bin/python3 ] && /opt/python/bin/python3 -m pip install --no-cache-dir "$@"; }

try V          inst_v
try Crystal    inst_crystal
try Odin       inst_odin
try Pony       inst_pony
try "Cairo (scarb)" inst_scarb
try "Solidity (solc)" inst_solc
try "HCL (OpenTofu)" inst_tofu
try "GDScript (Godot)" inst_godot
try J          inst_j
try BQN        inst_bqn
try Mojo       inst_pip mojo
try "Q#"       inst_pip qsharp

exit 0
