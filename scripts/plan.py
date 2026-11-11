#!/usr/bin/env python3
"""Gom các tag có cùng bộ ngôn ngữ -> build 1 lần, gắn nhiều tag. In ra matrix cho GitHub Actions."""
import json, os, sys

LANGS = ["node","python","php","ruby","go","rust","java","dotnet","kotlin","deno","bun",
         "swift","dart","scala","julia","zig"]
owner = os.environ.get("GITHUB_REPOSITORY_OWNER", "owner").lower()
only = (sys.argv[1] if len(sys.argv) > 1 else "").strip()
which = (sys.argv[2] if len(sys.argv) > 2 else "debian").strip() or "debian"   # debian | ubuntu | both
BASES = {"debian": ("ghcr.io/ptero-eggs/yolks:debian", ""),   # tag giữ nguyên: 14.5, latest ...
         "ubuntu": ("ubuntu:24.04", "-ubuntu")}                 # tag thêm hậu tố: 14.5-ubuntu ...
if which == "both": use = ["debian", "ubuntu"]
elif which in BASES: use = [which]
else: sys.exit("base phải là debian, ubuntu hoặc both, nhận được %r" % which)
image = "ghcr.io/%s/zfamily-multi" % owner

groups = {}
for r in json.load(open("versions.json")):
    if only and r["tag"] != only:
        continue
    key = tuple(r[l] for l in LANGS)
    groups.setdefault(key, []).append(r["tag"])

include = []
for b in use:
    base, suf = BASES[b]
    for key, tags in groups.items():
        names = list(tags)
        if "14.5" in tags and (not only or only == "14.5"):
            names.append("latest")
        entry = {"name": (tags[0] if len(tags) == 1 else tags[0] + "-" + tags[-1]) + suf,
                 "base": base,
                 "tags": "\n".join("%s:%s%s" % (image, t, suf) for t in names)}
        entry.update(dict(zip(LANGS, key)))
        include.append(entry)

if not include:
    sys.exit("Không có tag nào khớp: %r" % only)
out = json.dumps({"include": include}, ensure_ascii=False)
path = os.environ.get("GITHUB_OUTPUT")
if path:
    open(path, "a").write("matrix=%s\n" % out)
print(len(include), "bản build,", sum(len(g) for g in groups.values()) * len(use), "tag", file=sys.stderr)
