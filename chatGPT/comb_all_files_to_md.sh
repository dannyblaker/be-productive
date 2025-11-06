#!/bin/bash

# Specify the input directory
input_dir="./src"

# Specify the output file
output_file="./combined.md"

# Specify the directories to exclude
# exclude_dirs=("dir1" "dir2" "dir3")
exclude_dirs=("__tests__")

# Function to check if a directory should be excluded
should_exclude_directory() {
  local dir=$1
  
  for excluded_dir in "${exclude_dirs[@]}"; do
    if [[ "$dir" == "$excluded_dir" ]]; then
      return 0
    fi
  done
  
  return 1
}

# Function to recursively traverse the directory
traverse_directory() {
  local dir=$1
  local indent=$2
  
  for file in "$dir"/*; do
    if [[ -d "$file" ]]; then
      if should_exclude_directory "$(basename "$file")"; then
        continue
      fi
      
      traverse_directory "$file" "$indent  "
    elif [[ -f "$file" ]]; then
      echo "${indent}$(basename "$file")"
      echo '```'
      cat "$file"
      echo '```'
      echo
    fi
  done
}

# Remove the output file if it already exists
if [[ -f "$output_file" ]]; then
  rm "$output_file"
fi

# Traverse the input directory and append the contents to the output file
traverse_directory "$input_dir" "" >> "$output_file"
