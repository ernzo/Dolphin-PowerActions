#!/bin/bash

file_path="$1"

# Function to format size
format_size() {
    local size=$1
    if [ "$size" -ge 1073741824 ]; then
        echo "$((size / 1073741824)) GB"
    elif [ "$size" -ge 1048576 ]; then
        echo "$((size / 1048576)) MB"
    elif [ "$size" -ge 1024 ]; then
        echo "$((size / 1024)) KB"
    else
        echo "$size bytes"
    fi
}

# Extract file information
file_name=$(basename "$file_path")
file_type=$(file --brief "$file_path" | cut -d, -f1)
file_encoding=$(file --mime-encoding -b "$file_path")
file_size=$(stat -c%s "$file_path")
formatted_size=$(format_size "$file_size")
file_permissions=$(stat -c%A "$file_path")
file_owner=$(stat -c%U "$file_path")
file_mod_time=$(stat -c%y "$file_path")

# Fetch creation date
file_creation_date=$(stat -c%W "$file_path" 2>/dev/null)
if [ "$file_creation_date" -eq 0 ] 2>/dev/null; then
    file_creation_date="N/A"
else
    file_creation_date=$(date -d @"$file_creation_date" '+%d/%m/%Y %H:%M:%S' 2>/dev/null)
    if [ $? -ne 0 ]; then
        file_creation_date="N/A"
    fi
fi

file_magic_number=$(xxd -p -l 4 "$file_path" 2>/dev/null | tr -d '\n')
file_version=$(strings "$file_path" | grep -i 'version' | head -n 1)
md5_hash=$(md5sum "$file_path" | awk '{print $1}')
sha1_hash=$(sha1sum "$file_path" | awk '{print $1}')
sha256_hash=$(sha256sum "$file_path" | awk '{print $1}')
crc32_checksum=$(cksum -o 3 "$file_path" | awk '{print $1}' 2>/dev/null || echo "")

# Determine encryption
encrypted_status="None"

# Fetch extended attributes
xattrs=$(getfattr -d "$file_path" 2>/dev/null || echo "None")

# Display info
kdialog --title "File Information" --msgbox "File: $file_name\nPath: $file_path\n\nFile Type: $file_type\nMIME Type: $file_encoding\nEncoding: $file_encoding\nSize: $formatted_size\nOwner: $file_owner\nPermissions: $file_permissions\n\nVersion: ${file_version:-N/A}\nMagic Number: ${file_magic_number:-N/A}\nMD5 Hash: $md5_hash\nSHA-1 Hash: $sha1_hash\nSHA-256 Hash: $sha256_hash\nCRC32 CKS: ${crc32_checksum:-N/A}\nEncryption: $encrypted_status\nExtended Attributes: ${xattrs:-None}\nCreation Date: $file_creation_date\nLast Modification: $file_mod_time"
