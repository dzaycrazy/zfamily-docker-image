# zfamily-multi — Docker

Image: `ghcr.io/dzaycrazy/zfamily-multi:1`
Base: `ghcr.io/ptero-eggs/yolks:nodejs_25`

## Có sẵn
node.js 25 · ts-node · typescript · python 3.14 + pip · gcc · g++ · make · go · java (JDK) · ruby · php · perl · lua · rust + cargo · bubblewrap · git · curl

## Không đổi
ENTRYPOINT · CMD · USER `container` · WORKDIR `/home/container`

## Build
1. Đẩy code lên nhánh `main`.
2. GitHub Actions tự build và push lên GHCR.
3. Packages → `zfamily-multi` → Visibility → **Public**.

## Dùng trong panel
1. Startup → Docker image → **Custom image…**
2. Dán `ghcr.io/<tên-github-viết-thường>/zfamily-multi:1`
3. Restart server.
4. Startup command: giữ nguyên.

## Thêm ngôn ngữ
1. Sửa dòng `apt-get install` trong `Dockerfile`.
2. Push `main`.
3. Đổi tag trong panel (vd `:2`) → Restart.

## Lỗi
| Thấy | Làm |
|---|---|
| Console hiện `$` hoặc `I have no name!` | Image sai. Dùng image này. |
| Pull lỗi | Đặt package Public. |
| Server tắt ngay | Tăng RAM / disk của gói. |
| Thiếu ngôn ngữ | Sửa Dockerfile, build lại. |
| `apt` / `sudo` lúc chạy | Không dùng được. Sửa Dockerfile. |
