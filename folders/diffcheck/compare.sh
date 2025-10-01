#!/bin/bash

# Load environment variables from .env file
set -a
source .env
set +a


diff_files=$(diff -rq "$SRC" "$DEST")

if [ -z "$diff_files" ]; then
    echo "Success: All files are the same."
else
    echo "The following files are different:"
    echo "$diff_files"
fi