#!/bin/bash

set -a
source .env
set +a

echo "Counting files to be transferred..."
total_files=$(rsync -a --dry-run --out-format="%n" "$SRC" "$DEST" | grep -v '/$' | wc -l)
echo "Total files to transfer: $total_files"

if [ "$total_files" -eq 0 ]; then
    echo "No files need to be transferred."
    exit 0
fi

counter=0
while read -r line; do
    if [[ $line == FILE* ]]; then
        ((counter++))
        percent=$(( 100 * counter / total_files ))
        filename=$(echo "$line" | cut -d' ' -f2-)
        echo -ne "Progress: $percent% ($counter/$total_files) - $filename        \r"
    fi
done < <(rsync -a --out-format="FILE %n" "$SRC" "$DEST")

echo -e "\nDone."
