#!/bin/sh
# Convert the screenshots under content/ to webp next to their png. The
# image render hook serves the webp when one exists and falls back to the
# png when it does not, so converting is all a page needs. Run this after
# adding or replacing a screenshot; png files stay in the repo as the
# originals. Existing webp files are left alone unless their png is newer,
# or -f is given.
set -eu

cd "$(dirname "$0")"

LIBWEBP_VERSION=1.6.0
BIN_DIR=bin
QUALITY=90
ROOT=content

force=0
for arg in "$@"; do
    case "$arg" in
        -f|--force) force=1 ;;
        *) echo "usage: webp.sh [-f]" >&2; exit 1 ;;
    esac
done

cwebp_ok() {
    "$1" -version >/dev/null 2>&1
}

download_cwebp() {
    case "$(uname -s)" in
        Linux)  os=linux ;;
        Darwin) os=mac ;;
        *) echo "webp.sh: unsupported OS $(uname -s), install cwebp yourself" >&2; exit 1 ;;
    esac
    case "$(uname -m)" in
        x86_64) arch=x86-64 ;;
        aarch64|arm64)
            if [ "$os" = mac ]; then arch=arm64; else arch=aarch64; fi ;;
        *) echo "webp.sh: unsupported arch $(uname -m), install cwebp yourself" >&2; exit 1 ;;
    esac
    dir="libwebp-${LIBWEBP_VERSION}-${os}-${arch}"
    url="https://storage.googleapis.com/downloads.webmproject.org/releases/webp/${dir}.tar.gz"
    echo "downloading cwebp $LIBWEBP_VERSION ($os-$arch) into $BIN_DIR/"
    mkdir -p "$BIN_DIR"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$url" | tar -xz -C "$BIN_DIR" --strip-components=2 "$dir/bin/cwebp"
    else
        wget -qO- "$url" | tar -xz -C "$BIN_DIR" --strip-components=2 "$dir/bin/cwebp"
    fi
}

if [ -x "$BIN_DIR/cwebp" ] && cwebp_ok "$BIN_DIR/cwebp"; then
    CWEBP=$BIN_DIR/cwebp
elif command -v cwebp >/dev/null 2>&1 && cwebp_ok cwebp; then
    CWEBP=cwebp
else
    download_cwebp
    CWEBP=$BIN_DIR/cwebp
fi

list=$(mktemp)
trap 'rm -f "$list"' EXIT INT TERM
find "$ROOT" -type f -name '*.png' | sort > "$list"

converted=0
skipped=0
before=0
after=0

while read -r src; do
    dst="${src%.png}.webp"
    if [ "$force" -eq 0 ] && [ -f "$dst" ] && [ ! "$src" -nt "$dst" ]; then
        skipped=$((skipped + 1))
        continue
    fi
    "$CWEBP" -q "$QUALITY" -m 6 -quiet "$src" -o "$dst"
    png_size=$(wc -c < "$src")
    webp_size=$(wc -c < "$dst")
    before=$((before + png_size))
    after=$((after + webp_size))
    converted=$((converted + 1))
    printf '  %s  %dK -> %dK (%d%%)\n' \
        "$src" $((png_size / 1024)) $((webp_size / 1024)) \
        $((100 * webp_size / png_size))
done < "$list"

if [ "$converted" -eq 0 ]; then
    echo "webp.sh: nothing to do, $skipped already up to date"
else
    echo "webp.sh: converted $converted at q$QUALITY, skipped $skipped, $((before / 1024))K -> $((after / 1024))K"
fi
