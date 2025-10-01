#!/bin/bash

# delete empty directories in current directory and subdirectories

while true; do
    output=$(sudo find . -type d -empty -exec rmdir {} \; 2>&1)
    echo "$output"
    if [ -z "$output" ]; then
        echo "Output is empty."
        break
    fi
done