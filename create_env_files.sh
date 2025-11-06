#!/bin/bash

# Start from project root (.)
# Find all files named 'env-sample'
# For each one, copy its contents to a '.env' file in the same directory

find . -type f -name "env-sample" | while read -r sample_file; do
  dir="$(dirname "$sample_file")"
  cp "$sample_file" "$dir/.env"
  echo "Created .env in $dir"
done