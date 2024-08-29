#!/bin/bash

file_path="$1"

# Format Size
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

# Extract Info
file_name=$(basename "$file_path")
file_type=$(file --brief "$file_path" | cut -d, -f1)
file_encoding=$(file --mime-encoding -b "$file_path")
file_size=$(stat -c%s "$file_path")
formatted_size=$(format_size "$file_size")
file_permissions=$(stat -c%A "$file_path")
file_owner=$(stat -c%U "$file_path")
file_mod_time=$(stat -c%y "$file_path")

# Creation Date
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

# Encryption Detection
encrypted_status="Not Encrypted"

# Check by extension
if [[ "$file_name" =~ \.(gpg|aes|enc|encr|crypt|ssl|pem|der|key|p12)$ ]]; then
    encrypted_status="Encrypted (extension)"
fi

# Check Encryption
if file "$file_path" | grep -qi "encrypted"; then
    encrypted_status="Encrypted (file command)"
fi

# Calculate Entropy
if [ "$file_size" -gt 0 ]; then
    entropy=$(xxd -p "$file_path" | tr -d '\n' | fold -w2 | sort | uniq -c | awk '{sum+=-($1/'"$file_size"')*log($1/'"$file_size"')/log(2)} END {print sum}')
    # High Threshold (AES, Blowfish, Twofish, ChaCha20, etc.)
    if (( $(echo "$entropy > 7.8" | bc -l) )); then
        encrypted_status="Encrypted (entropy)"
    fi
else
    encrypted_status="Unknown (empty)"
fi

# Headers/footers
if grep -q -E "BEGIN (RSA|EC) PRIVATE KEY|BEGIN PUBLIC KEY|BEGIN ENCRYPTED PRIVATE KEY|BEGIN EC PARAMETERS|-----BEGIN (ENCRYPTED|PGP|GPG) MESSAGE-----|-----BEGIN (PGP|GPG) PUBLIC KEY BLOCK-----" "$file_path"; then
    encrypted_status="Encrypted (RSA/ECC Key or PGP/GPG)"
fi

# Common Patterns
if grep -q -E "(Salted|iv:[0-9a-fA-F]{16}|[0-9a-fA-F]{32,})" "$file_path"; then
    encrypted_status="Encrypted (common patterns)"
fi

# Extended Attributes
xattrs=$(getfattr -d "$file_path" 2>/dev/null || echo "None")

# Display Info
kdialog --title "Extended File Information" --msgbox "File: $file_name\nPath: $file_path\n\nFile Type: $file_type\nMIME Type: $file_encoding\nEncoding: $file_encoding\nSize: $formatted_size\nOwner: $file_owner\nPermissions: $file_permissions\n\nVersion: ${file_version:-N/A}\nMagic Number: ${file_magic_number:-N/A}\nMD5 Hash: $md5_hash\nSHA-1 Hash: $sha1_hash\nSHA-256 Hash: $sha256_hash\nCRC32 CKS: ${crc32_checksum:-N/A}\nEncryption: $encrypted_status\nExtended Attributes: ${xattrs:-None}\nCreation Date: $file_creation_date\nLast Modification: $file_mod_time"
