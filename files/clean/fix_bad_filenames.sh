#!/usr/bin/env bash
set -euo pipefail

# sanitize_names.sh
# Recursively rename files/dirs to remove problematic characters and shorten long names.
#
# Default: dry-run (prints what it would do).
# Use --apply to actually rename.
#
# Examples:
#   ./sanitize_names.sh "/path/to/folder"
#   ./sanitize_names.sh --apply --max-name 100 "/path/to/folder"
#   ./sanitize_names.sh --apply --max-name 120 --keep-ext "/path/to/folder"

ROOT="${1:-}"
APPLY=0
MAX_NAME=120
KEEP_EXT=1

usage() {
  cat <<'USAGE'
Usage:
  sanitize_names.sh [--apply] [--max-name N] [--keep-ext|--no-keep-ext] <root-folder>

Options:
  --apply            Perform renames (otherwise dry-run).
  --max-name N       Max length of a single path component (file/dir name). Default 120.
  --keep-ext         Try to preserve file extension when truncating (default).
  --no-keep-ext      Truncate whole name without preserving extension.

Notes:
  - This targets Windows-hostile characters: <>:"/\|?* plus control chars.
  - It also trims trailing dots/spaces (Windows hates those).
  - It renames deepest paths first (find -depth) to avoid breaking traversal.
USAGE
}

# Parse args
ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply) APPLY=1; shift ;;
    --max-name) MAX_NAME="${2:?Missing N}"; shift 2 ;;
    --keep-ext) KEEP_EXT=1; shift ;;
    --no-keep-ext) KEEP_EXT=0; shift ;;
    -h|--help) usage; exit 0 ;;
    *)
      ARGS+=("$1"); shift ;;
  esac
done

if [[ ${#ARGS[@]} -lt 1 ]]; then
  usage
  exit 1
fi

ROOT="${ARGS[0]}"

if [[ ! -d "$ROOT" ]]; then
  echo "Error: '$ROOT' is not a directory"
  exit 1
fi

# Replace Windows-hostile characters and control chars.
# Also normalize whitespace runs to single spaces, then spaces to underscores (optional style).
sanitize_component() {
  local name="$1"

  # Replace control chars with underscore
  name="$(printf '%s' "$name" | tr -d '\000' | tr '[:cntrl:]' '_')"

  # Replace Windows-illegal: <>:"/\|?*
  # (Linux allows most, but tools/filesystems may not.)
  name="$(printf '%s' "$name" | sed -E 's/[<>:"\\|?*]/_/g')"

  # Optional: replace spaces with underscores (comment out if you want to keep spaces)
  name="$(printf '%s' "$name" | sed -E 's/[[:space:]]+/_/g')"

  # Trim trailing dots/spaces/underscores (Windows disallows trailing dots/spaces)
  name="$(printf '%s' "$name" | sed -E 's/[._ ]+$//g')"

  # Avoid empty names
  if [[ -z "$name" ]]; then
    name="_"
  fi

  printf '%s' "$name"
}

# Truncate to MAX_NAME with hash suffix to avoid collisions.
# Keeps extension if KEEP_EXT=1 and there's a reasonable extension.
truncate_component() {
  local name="$1"
  local max="$2"

  local nlen="${#name}"
  if (( nlen <= max )); then
    printf '%s' "$name"
    return 0
  fi

  # Create a stable short hash from full original name
  local h
  h="$(printf '%s' "$name" | sha1sum | awk '{print substr($1,1,8)}')"

  if (( KEEP_EXT == 1 )); then
    # Split extension if present (simple heuristic)
    local base="$name"
    local ext=""
    if [[ "$name" == *.* && "$name" != .* ]]; then
      ext=".${name##*.}"
      base="${name%.*}"
      # If ext is absurdly long, treat as no extension
      if (( ${#ext} > 16 )); then
        ext=""
        base="$name"
      fi
    fi

    # Reserve space for "_" + hash + ext
    local suffix="_${h}${ext}"
    local keep=$(( max - ${#suffix} ))
    if (( keep < 1 )); then
      # Not enough room; drop ext
      suffix="_${h}"
      keep=$(( max - ${#suffix} ))
      if (( keep < 1 )); then
        # Extreme: just return hash cut to max
        printf '%s' "${h:0:max}"
        return 0
      fi
    fi

    printf '%s' "${base:0:keep}${suffix}"
  else
    local suffix="_${h}"
    local keep=$(( max - ${#suffix} ))
    if (( keep < 1 )); then
      printf '%s' "${h:0:max}"
      return 0
    fi
    printf '%s' "${name:0:keep}${suffix}"
  fi
}

rename_path() {
  local path="$1"

  local dir
  dir="$(dirname -- "$path")"
  local name
  name="$(basename -- "$path")"

  local new_name
  new_name="$(sanitize_component "$name")"
  new_name="$(truncate_component "$new_name" "$MAX_NAME")"

  if [[ "$new_name" == "$name" ]]; then
    return 0
  fi

  local target="${dir}/${new_name}"

  # If target already exists, append incrementing suffix
  if [[ -e "$target" ]]; then
    local i=1
    while [[ -e "${target}_${i}" ]]; do
      ((i++))
    done
    target="${target}_${i}"
  fi

  if (( APPLY == 0 )); then
    printf 'DRY:  %q -> %q\n' "$path" "$target"
  else
    printf 'DO:   %q -> %q\n' "$path" "$target"
    mv -n -- "$path" "$target"
  fi
}

export -f sanitize_component truncate_component rename_path
export MAX_NAME APPLY KEEP_EXT

# Depth-first to rename children before parents
# -print0 handles weird characters safely.
find "$ROOT" -depth -print0 | while IFS= read -r -d '' p; do
  # Skip the root directory itself (don’t rename it)
  [[ "$p" == "$ROOT" ]] && continue
  rename_path "$p"
done

echo "Done. (Mode: $([[ $APPLY -eq 1 ]] && echo apply || echo dry-run))"
