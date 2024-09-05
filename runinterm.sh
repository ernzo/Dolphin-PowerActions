#!/bin/bash
# Run in Term

file_path="$1"

# File exists?
if [[ -e "$file_path" ]]; then
    # Execute
    "$file_path"
else
    # If not a File, assume Command
    echo "Running command: \"$file_path\""
    "$file_path"
fi
