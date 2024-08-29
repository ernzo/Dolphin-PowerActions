#!/bin/bash
# Add execute permission to file/s
for file in "$@"; do
    chmod +x "$file"

    if [ $? -ne 0 ]; then
        echo "Failed updating permission for $file, retry with sudo..."
        sudo chmod +x "$file"

        if [ $? -eq 0 ]; then
            echo "Updated Execute Permission for $file"
        else
            echo "Failed updating permission for $file with sudo"
        fi
    else
        echo "Updated Execute Permission for $file"
    fi
done
