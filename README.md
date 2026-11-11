# zfamily-multi — Docker

Image: `ghcr.io/dzaycrazy/zfamily-multi`
Base: `ghcr.io/ptero-eggs/yolks:debian` (bản Ubuntu: `ubuntu:24.04`)

## Có sẵn
Theo tag (xem bảng dưới): node · python · php · ruby · go · rust · java · dotnet · kotlin · deno · bun · swift · dart · scala · julia · zig

Mọi tag: typescript · ts-node · gcc · g++ · clang · make · perl · lua · R · haskell · elixir · erlang · ocaml · fortran · pascal · lisp · cobol · nasm · objective-c · sqlite3 · git · curl · bubblewrap

Cài thêm (mọi tag, bản mới nhất):
- apt: awk · tcl · prolog · scheme · racket · forth · smalltalk · ada · d · nim · crystal · haxe · raku · vala · verilog · vhdl · apl · ats · octave · groovy · clojure · protobuf · psql · mariadb · luajit · pypy · zsh · fish · mingw-w64
- GitHub / build từ nguồn: powershell · gleam · v · odin · pony · cairo (`scarb`) · solc · hcl (`tofu`) · gdscript (`godot --headless`) · j · bqn
- pip: mojo · qsharp
- npm: coffeescript · assemblyscript · rescript · purescript · elm (cần Node ≥ 18)

Không có: MATLAB, SAS, Stata, Wolfram, GAMS, LabVIEW, ABAP, Apex, X++ (cần giấy phép) · T-SQL, PL/SQL (cần SQL Server / Oracle) · VBScript, ActionScript, ColdFusion, Scratch, Move, Reason.

## Không đổi
ENTRYPOINT · CMD · USER `container` · WORKDIR `/home/container`

## Tag
15 tag, rải từ 2016-04-26 đến 2026-11-11. Mỗi tag là một bộ version ngôn ngữ. `14.5` = bản mới nhất (`latest`). Tag cùng bộ version được build chung một lần.
Bản Ubuntu thêm hậu tố `-ubuntu` (`14.5-ubuntu`, `latest-ubuntu`).

| tag | ngày | node | python | php | ruby | go | rust | java | dotnet | kotlin | deno | bun | swift | dart | scala | julia | zig |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1.0 | 2016-04-26 | 6 | 3.5 | 7.0 | 2.3 | 1.6 | 1.8.0 | 8 | 2.0 | 1.0 | 1 | 1.0 | 3.0 | 1 | 2.11 | 0.5 | 0.4 |
| 2.0 | 2017-01-26 | 7 | 3.6 | 7.1 | 2.4 | 1.7 | 1.14.0 | 8 | 2.0 | 1.0 | 1 | 1.0 | 3.0 | 1 | 2.12 | 0.5 | 0.4 |
| 3.0 | 2017-10-28 | 8 | 3.6 | 7.1 | 2.4 | 1.9 | 1.21.0 | 8 | 2.0 | 1.1 | 1 | 1.0 | 4.0 | 1 | 2.12 | 0.6 | 0.4 |
| 4.0 | 2018-07-30 | 10 | 3.7 | 7.2 | 2.5 | 1.10 | 1.27.0 | 8 | 2.1 | 1.2 | 1 | 1.0 | 4.1 | 1 | 2.12 | 0.6 | 0.4 |
| 5.0 | 2019-05-01 | 12 | 3.7 | 7.3 | 2.6 | 1.12 | 1.34.0 | 11 | 2.2 | 1.3 | 1 | 1.0 | 5.0 | 2.0 | 2.12 | 1.1 | 0.4 |
| 6.0 | 2020-01-31 | 13 | 3.8 | 7.4 | 2.7 | 1.13 | 1.41.0 | 11 | 3.1 | 1.3 | 1 | 1.0 | 5.1 | 2.7 | 2.13 | 1.3 | 0.5 |
| 7.0 | 2020-11-01 | 15 | 3.9 | 7.4 | 2.7 | 1.15 | 1.47.0 | 11 | 3.1 | 1.4 | 1 | 1.0 | 5.3 | 2.10 | 2.13 | 1.5 | 0.6 |
| 8.0 | 2021-08-04 | 16 | 3.9 | 8.0 | 3.0 | 1.16 | 1.54.0 | 11 | 5.0 | 1.5 | 1 | 1.0 | 5.4 | 2.12 | 3.0 | 1.6 | 0.8 |
| 9.0 | 2022-05-06 | 18 | 3.10 | 8.1 | 3.1 | 1.18 | 1.60.0 | 17 | 6.0 | 1.6 | 1 | 1.0 | 5.6 | 2.15 | 3.0 | 1.7 | 0.9 |
| 10.0 | 2023-02-05 | 19 | 3.11 | 8.2 | 3.2 | 1.20 | 1.67.0 | 17 | 7.0 | 1.8 | 1 | 1.0 | 5.7 | 2.19 | 3.0 | 1.8 | 0.10 |
| 11.0 | 2023-11-07 | 21 | 3.12 | 8.2 | 3.2 | 1.21 | 1.73.0 | 21 | 7.0 | 1.9 | 1 | 1.0 | 5.9 | 3.0 | 3.3 | 1.9 | 0.11 |
| 12.0 | 2024-08-08 | 22 | 3.12 | 8.3 | 3.3 | 1.22 | 1.80.0 | 21 | 8.0 | 2.0 | 1 | 1.1 | 5.10 | 3.5 | 3.3 | 1.10 | 0.13 |
| 13.0 | 2025-05-10 | 24 | 3.13 | 8.4 | 3.4 | 1.24 | 1.86.0 | 21 | 9.0 | 2.1 | 2 | 1.2 | 6.1 | 3.7 | 3.3 | 1.11 | 0.14 |
| 14.0 | 2026-02-09 | 25 | 3.14 | 8.5 | 4.0 | 1.25 | 1.93.0 | 25 | 10.0 | 2.2 | 2 | 1.3 | 6.2 | 3.9 | 3.3 | 1.12 | 0.15 |
| 14.5 | 2026-11-11 | 25 | 3.14 | 8.5 | 4.0 | latest | stable | 25 | 10.0 | latest | latest | latest | latest | latest | latest | latest | latest |

Ô `latest` / `stable` = lấy bản mới nhất lúc build.

## Hệ điều hành
| | |
|---|---|
| Linux (Debian) | Mặc định. |
| Ubuntu 24.04 | Tag `-ubuntu`. |
| Windows | Không chạy được trong image Linux (container dùng kernel của host). Có mingw-w64 để biên dịch ra `.exe`; Go, Rust cũng biên dịch chéo ra Windows được. |

## Dùng trong panel
1. Startup → Docker image → **Custom image…**
2. Dán `ghcr.io/dzaycrazy/zfamily-multi:14.5`
3. Restart server.
4. Startup command: giữ nguyên.

## Build
- Push `main`: build Debian, cả 15 tag.
- Actions → build-image → Run workflow: `only` = một tag (vd `14.5`), `base` = `debian` / `ubuntu` / `both`.
- Package phải để Public.
- Log build có `[bỏ qua] <tên>`: ngôn ngữ đó không cài được, các ngôn ngữ còn lại vẫn có.

## Thêm ngôn ngữ
1. Có trong apt: thêm tên gói vào vòng `for p in ...` trong `Dockerfile`.
2. Không có trong apt: thêm hàm vào `scripts/install-extras.sh`.
3. Cần theo từng tag: thêm `scripts/install-<tên>.sh`, một stage trong `Dockerfile`, cột trong `versions.json` và `LANGS` trong `scripts/plan.py`.
4. Đổi version của tag: sửa `versions.json` (đừng chạy lại `scripts/gen_versions.py`, nó ghi đè).
5. Push `main`, đổi tag trong panel → Restart.

## Lỗi
| Thấy | Làm |
|---|---|
| Console hiện `$` hoặc `I have no name!` | Image sai. Dùng image này. |
| Pull lỗi | Đặt package Public. |
| Server tắt ngay | Tăng RAM / disk của gói. Image nặng. |
| Thiếu ngôn ngữ | Xem log build tìm `[bỏ qua]`, sửa Dockerfile, build lại. |
| `apt` / `sudo` lúc chạy | Không dùng được. Sửa Dockerfile. |
