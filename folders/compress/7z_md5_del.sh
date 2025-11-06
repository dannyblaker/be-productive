#!/bin/bash

# verify-7z-archive.sh
# - Hardcoded SRC and DEST
# - Zips SRC to DEST
# - Compares MD5s before/after extraction
# - Deletes SRC if everything matches

set -a
source .env
set +a

set -Eeuo pipefail
IFS=$'\n\t'


log() { printf '[%s] %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*" >&2; }

# ---- sanity checks ----
if [[ ! -d "$SRC" ]]; then
  echo "Error: SRC must be an existing directory: $SRC" >&2
  exit 2
fi

if [[ -e "$DEST" ]]; then
  echo "Error: DEST archive already exists: $DEST" >&2
  exit 2
fi

for bin in 7z md5sum find xargs sort mktemp; do
  command -v "$bin" >/dev/null 2>&1 || { echo "Missing dependency: $bin" >&2; exit 3; }
done

# ---- work dirs ----
WORK_DIR="$(mktemp -d -t verify7z.XXXXXXXX)"
EXTRACT_DIR="$(mktemp -d -t verify7z_extract.XXXXXXXX)"
SRC_MD5="$WORK_DIR/SRC_md5.txt"
EXT_MD5="$WORK_DIR/extracted_md5.txt"

cleanup() {
  if [[ "${KEEP_EXTRACT_ON_FAIL:-0}" = "1" ]]; then
    log "Preserving extracted files at: $EXTRACT_DIR (failure mode)"
  else
    rm -rf -- "$EXTRACT_DIR" || true
  fi
  rm -rf -- "$WORK_DIR" || true
}
trap cleanup EXIT

md5_tree() {
  local root="$1" out="$2"
  ( cd "$root"
    LC_ALL=C find . -type f -print0 \
      | LC_ALL=C sort -z \
      | xargs -0 md5sum -- > "$out"
  )
}

# ---- 1) Hash SRC ----
log "Hashing SRC: $SRC"
md5_tree "$SRC" "$SRC_MD5"

# ---- 2) Create archive ----
SRC_PARENT="$(dirname -- "$(readlink -f -- "$SRC")")"
SRC_BASE="$(basename -- "$SRC")"
log "Creating archive: $DEST"
(
  cd "$SRC_PARENT"
  7z a -bd -y -- "$DEST" "$SRC_BASE" >/dev/null
)

# ---- 3) Test archive ----
log "Testing archive"
7z t -bd -- "$DEST" >/dev/null

# ---- 4) Extract ----
log "Extracting to $EXTRACT_DIR"
7z x -bd -y -o"$EXTRACT_DIR" -- "$DEST" >/dev/null

if [[ ! -d "$EXTRACT_DIR/$SRC_BASE" ]]; then
  echo "Error: expected directory $SRC_BASE missing in extraction" >&2
  KEEP_EXTRACT_ON_FAIL=1
  exit 4
fi

# ---- 5) Hash extracted ----
log "Hashing extracted files"
md5_tree "$EXTRACT_DIR/$SRC_BASE" "$EXT_MD5"

# ---- 6) Compare ----
if ! cmp -s "$SRC_MD5" "$EXT_MD5"; then
  log "MD5 mismatch! Archive is NOT identical."
  diff -u "$SRC_MD5" "$EXT_MD5" || true
  KEEP_EXTRACT_ON_FAIL=1
  exit 5
fi

log "Verification succeeded, hashes match."

# ---- 7) Delete SRC ----
log "Deleting SRC: $SRC"
rm -rf -- "$SRC"

log "Done. Archive at: $DEST"
