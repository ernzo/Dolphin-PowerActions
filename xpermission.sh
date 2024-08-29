#!/bin/bash
# Add execute permission to file/s
for file in "$@"; do
    chmod +x "$file"
    echo "Updated Execute Permission for $file"
done
