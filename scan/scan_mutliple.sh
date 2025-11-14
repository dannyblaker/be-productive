#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scan_pages <NUM_PAGES> [OUTPUT_PDF]

Examples:
  ./scan_pages 2
  ./scan_pages 5 my_scan.pdf
  ./scan_pages 5 my_scan   # automatically becomes my_scan.pdf

Notes:
  - Requires 'scanimage' (SANE) and 'convert' (ImageMagick).
  - Prompts you before scanning each page.
EOF
}

# ---- args ----
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" || $# -lt 1 ]]; then
  usage; exit 0
fi

NUM_PAGES="${1:-}"
if ! [[ "$NUM_PAGES" =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: NUM_PAGES must be a positive integer." >&2
  usage; exit 1
fi

DOC_NAME="${2:-doc.pdf}"

# Automatically add .pdf if missing
if [[ "$DOC_NAME" != *.pdf ]]; then
  DOC_NAME="${DOC_NAME}.pdf"
fi

# ---- deps ----
command -v scanimage >/dev/null 2>&1 || { echo "Error: 'scanimage' not found."; exit 1; }
command -v convert   >/dev/null 2>&1 || { echo "Error: 'convert' (ImageMagick) not found."; exit 1; }

# ---- temp workspace & cleanup ----
TMPDIR="$(mktemp -d)"
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

# ---- scan loop ----
for (( i=1; i<=NUM_PAGES; i++ )); do
  printf "Place page %d on the scanner and press Enter..." "$i"
  read -r
  echo "Scanning page $i..."
  OUT_PNG="$TMPDIR/page$(printf "%04d" "$i").png"
  scanimage --mode Color --resolution 300 --format=png > "$OUT_PNG"
done

# ---- assemble PDF ----
echo "Combining pages into '$DOC_NAME'..."
convert "$TMPDIR"/page*.png -density 300 "$DOC_NAME"

echo "Done: $DOC_NAME"
