#!/bin/bash
# Add Execute Permission to file/s

# Check filename/s
if [ $# -eq 0 ]; then
    echo "Usage: $0 filename [filename2 ...]"
    exit 1
fi

# Tracking Flag
first_file=true

# Loop through filename/s
for file in "$@"; do
    file_path="$file"

    if [[ -e "$file_path" ]]; then
        if [[ "$first_file" = false ]]; then
            echo -e "\n---\n"
        fi

        # Print file details
        echo "File details for \"$file_path\":"
        stat --format='%A %h %U/%G' "$file_path"
        echo

        # Add execute permission to file/s
        chmod +x "$file_path"

        if [[ $? -ne 0 ]]; then
            echo "Failed to update permission for \"$file_path\", retry with sudo..."
            sudo chmod +x "$file_path"

            if [[ $? -eq 0 ]]; then
                echo "Updated execute permission for \"$file_path\" with sudo."
            else
                echo "Failed to update permission for \"$file_path\" with sudo."
            fi
        else
            echo "Updated execute permission for \"$file_path\"."
        fi

        # File details after updating
        stat --format='%A %h %U/%G' "$file_path"
        echo

        # Tracking Flag
        first_file=false

    else
        echo "File \"$file_path\" does not exist."
    fi
done

if [[ "$first_file" = false ]]; then
    echo -e "\n---\n"
fi
