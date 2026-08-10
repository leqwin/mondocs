#!/bin/sh
set -eu

cd "$(dirname "$0")"

HUGO_VERSION=0.148.2
MIN_MINOR=146
BIN_DIR=bin

hugo_ok() {
    minor=$("$1" version 2>/dev/null | sed -n 's/^hugo v0\.\([0-9]*\).*/\1/p')
    [ -n "$minor" ] && [ "$minor" -ge "$MIN_MINOR" ]
}

download_hugo() {
    case "$(uname -s)" in
        Linux)  os=linux ;;
        Darwin) os=darwin ;;
        *) echo "build.sh: unsupported OS $(uname -s), install Hugo 0.$MIN_MINOR+ yourself" >&2; exit 1 ;;
    esac
    case "$(uname -m)" in
        x86_64)        arch=amd64 ;;
        aarch64|arm64) arch=arm64 ;;
        *) echo "build.sh: unsupported arch $(uname -m), install Hugo 0.$MIN_MINOR+ yourself" >&2; exit 1 ;;
    esac
    [ "$os" = darwin ] && arch=universal
    url="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_${os}-${arch}.tar.gz"
    echo "downloading hugo $HUGO_VERSION ($os-$arch) into $BIN_DIR/"
    mkdir -p "$BIN_DIR"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$url" | tar -xz -C "$BIN_DIR" hugo
    else
        wget -qO- "$url" | tar -xz -C "$BIN_DIR" hugo
    fi
}

if [ -x "$BIN_DIR/hugo" ] && hugo_ok "$BIN_DIR/hugo"; then
    HUGO=$BIN_DIR/hugo
elif command -v hugo >/dev/null 2>&1 && hugo_ok hugo; then
    HUGO=hugo
else
    download_hugo
    HUGO=$BIN_DIR/hugo
fi

# enableGitInfo dates each page from its last commit, so it needs a git
# checkout; a source tarball has none, and hugo makes that a hard error.
if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "no git checkout, building without per-page dates"
    export HUGO_ENABLEGITINFO=false
fi

"$HUGO" --gc --cleanDestinationDir
echo "built into public/"
