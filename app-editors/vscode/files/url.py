#!/usr/bin/env python3
import os
import sys

import yaml

ARCH = ("x64", "arm64", "riscv64", "loong64")
LIBCS = ("glibc", "musl")
LOCKFILES = (
    "pnpm-lock.yaml",
    "build/pnpm-lock.yaml",
    "remote/pnpm-lock.yaml",
    "extensions/pnpm-lock.yaml",
    "extensions/copilot/pnpm-lock.yaml",
)


def ok(v, wanted, field):
    f = v.get(field)
    if not f:
        return True
    f = [str(x) for x in f]
    if any(x.startswith("!") for x in f):
        return all("!" + w not in f for w in wanted)
    return any(w in f for w in wanted)


def load(root, relpath):
    path = os.path.join(root, relpath)
    try:
        with open(path) as f:
            return yaml.safe_load(f)
    except FileNotFoundError:
        return None


def main():
    if len(sys.argv) != 2:
        sys.exit(f"usage: {sys.argv[0]} <vscode-repo-dir>")
    root = sys.argv[1]
    if not os.path.isdir(root):
        sys.exit(f"{root}: not a directory")
    urls = set()
    for relpath in LOCKFILES:
        d = load(root, relpath)
        if not d:
            continue
        # "packages" carries the os/cpu/libc metadata in both v6 and v9
        # lockfiles; only fall back to "snapshots" for unusual lockfiles
        # (in v9 snapshots only repeat the graph without platform metadata).
        section = "packages" if d.get("packages") else "snapshots"
        for key, meta in (d.get(section) or {}).items():
            if not isinstance(meta, dict):
                continue
            if not ok(meta, ("linux",), "os") or not ok(meta, ARCH, "cpu"):
                continue
            if not ok(meta, LIBCS, "libc"):
                continue
            # local/workspace packages (e.g. file: dependencies) have no
            # registry tarball, only a directory resolution.
            if "integrity" not in (meta.get("resolution") or {}):
                continue
            # drop peer-dependency suffix and the leading slash that
            # lockfile v6 keeps in front of package keys
            name, _, ver = key.split("(", 1)[0].rpartition("@")
            name = name.lstrip("/")
            base = name.split("/")[-1]
            urls.add(f"https://registry.npmjs.org/{name}/-/{base}-{ver}.tgz")
    print("\n".join(sorted(urls)))


if __name__ == "__main__":
    main()
