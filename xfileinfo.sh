#!/bin/bash

declare -A cache

# Get path
file_path="$1"

format_size() {
    local size=$1

    format_with_commas() {
        local num=$1
        echo "$num" | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta'
    }

    # Convert to appropriate units
    if [ "$size" -ge 1073741824 ]; then
        local main_size=$(echo "scale=2; $size / 1073741824" | bc 2>/dev/null | sed 's/\./,/')  # GiB
        echo "$main_size GiB ($(format_with_commas $(echo "scale=3; $size / 1024" | bc 2>/dev/null)) KiB)"
    elif [ "$size" -ge 1048576 ]; then
        local main_size=$(echo "scale=2; $size / 1048576" | bc 2>/dev/null | sed 's/\./,/')  # MiB
        local next_size=$(echo "scale=3; $size / 1024" | bc 2>/dev/null | sed 's/\./,/')  # KiB
        echo "$main_size MiB ($(format_with_commas $next_size) KiB)"
    elif [ "$size" -ge 1024 ]; then
        local main_size=$(echo "scale=2; $size / 1024" | bc 2>/dev/null | sed 's/\./,/')  # KiB
        local next_size=$(format_with_commas $size)  # Bytes
        echo "$main_size KiB ($next_size bytes)"
    else
        echo "$size bytes"
    fi
}

# Retrieve Cache value by key
retrieve_cache() {
    local key="$1"
    echo "${cache[$key]}"
}

# Set Cache key-value pair
set_cache() {
    local key="$1"
    local value="$2"
    cache["$key"]="$value"
}

# Generate Cache if missing
if [ -z "$(retrieve_cache "file_size")" ]; then
    echo "Generating cache for $file_path..." >&2

    # Get file Size and set Cache
    file_size=$(stat -c%s "$file_path")
    set_cache "file_size" "$file_size"
    set_cache "formatted_size" "$(format_size "$file_size")"

    # Calculate Hashes
    md5_hash=$(md5sum "$file_path" | awk '{print $1}')
    sha1_hash=$(sha1sum "$file_path" | awk '{print $1}')
    sha256_hash=$(sha256sum "$file_path" | awk '{print $1}')
    crc32_checksum=$(cksum "$file_path" | awk '{print $1}' 2>/dev/null || echo "")

    set_cache "md5_hash" "$md5_hash"
    set_cache "sha1_hash" "$sha1_hash"
    set_cache "sha256_hash" "$sha256_hash"
    set_cache "crc32_checksum" "$crc32_checksum"

    # Encryption detection
    encrypted_status="Not Encrypted"
    mime_status="Not Encrypted"

    # Check by file extension
    if [[ "$file_path" =~ \.(gpg|aes|enc|encr|crypt|ssl|pem|der|key|p12)$ ]]; then
        encrypted_status="Encrypted (extension)"
    fi

    # Check MIME type for hints
    file_info=$(file --brief --mime-type "$file_path")
    if [[ "$file_info" == "application/octet-stream" ]]; then
        mime_status="Possible Encrypted (application/octet-stream)"
    fi

    # Final Encryption status
    if [[ "$encrypted_status" == "Not Encrypted" && "$mime_status" == "Not Encrypted" ]]; then
        final_encrypted_status="Not Encrypted"
    else
        final_encrypted_status="$encrypted_status, $mime_status"
    fi

    # Entropy calculation
    if [ "$file_size" -gt 0 ]; then
        sample_size=10485760  # 10 MB
        if [ "$file_size" -lt $sample_size ]; then
            sample_size="$file_size"
        fi

        # Extract sample, compute entropy
        sample=$(head -c "$sample_size" "$file_path" | xxd -p | tr -d '\n')
        if [ -n "$sample" ]; then
            # Shannon entropy for accurate assessment
            entropy=$(echo "$sample" | fold -w2 | sort | uniq -c | awk -v size="$sample_size" '
                {
                    freq[$2] += $1
                }
                END {
                    entropy = 0
                    for (i in freq) {
                        p = freq[i] / size
                        if (p > 0) {
                            entropy -= p * log(p) / log(2)
                        }
                    }
                    print entropy
                }' 2>/dev/null)
            if [ $? -ne 0 ]; then
                final_encrypted_status="Unknown (error)"
            elif [ -n "$entropy" ] && (( $(echo "$entropy > 7.8" | bc -l) )); then
                final_encrypted_status="Encrypted (entropy)"
            fi
        else
            final_encrypted_status="Unknown (extraction error)"
        fi
    else
        final_encrypted_status="Unknown (empty)"
    fi

    # Check for RSA/ECC or PGP/GPG keys and common patterns
    if grep -q -E "BEGIN (RSA|EC) PRIVATE KEY|BEGIN PUBLIC KEY|BEGIN ENCRYPTED PRIVATE KEY|BEGIN EC PARAMETERS|-----BEGIN (ENCRYPTED|PGP|GPG) MESSAGE-----|-----BEGIN (PGP|GPG) PUBLIC KEY BLOCK-----" "$file_path"; then
        final_encrypted_status="Encrypted (RSA/ECC Key or PGP/GPG)"
    elif grep -q -E "(Salted|iv:[0-9a-fA-F]{16}|[0-9a-fA-F]{32,})" "$file_path"; then
        final_encrypted_status="Encrypted (common patterns)"
    fi

    set_cache "encrypted_status" "$final_encrypted_status"
else
    echo "Using cached information for $file_path..." >&2
fi

# Get file information (non-cached)
file_name=$(basename "$file_path")
file_type=$(file --brief "$file_path" | cut -d, -f1)
file_encoding=$(file --mime-encoding -b "$file_path")
file_permissions=$(stat -c%A "$file_path")
file_owner=$(stat -c%U "$file_path")
file_mod_time=$(date -d "$(stat -c %y "$file_path")" '+%Y-%m-%d %H:%M:%S %Z')

# Extended Attributes
xattrs=$(getfattr -d "$file_path" 2>/dev/null || echo "None")

# Creation Date
file_creation_date=$(stat -c%W "$file_path" 2>/dev/null)
if [ "$file_creation_date" -eq 0 ] 2>/dev/null; then
    file_creation_date="N/A"
else
    file_creation_date=$(date -d @"$file_creation_date" '+%d/%m/%Y %H:%M:%S' 2>/dev/null)
    if [ $? -ne 0 ]; then
        file_creation_date="N/A (Parse Error)"
    fi
fi

# Magic Number
file_magic_number=$(xxd -p -l 4 "$file_path" 2>/dev/null | tr -d '\n')
file_version=""

# Extract Version info based on file type
if [[ "$file_name" =~ \.deb$ ]]; then
    file_version=$(dpkg-deb -I "$file_path" 2>/dev/null | grep '^ Version: ' | awk '{print $2}')
elif [[ "$file_name" =~ \.rpm$ ]]; then
    file_version=$(rpm -qp "$file_path" --queryformat '%{VERSION}-%{RELEASE}\n' 2>/dev/null)
elif [[ "$file_name" =~ \.AppImage$ ]]; then
    file_version=$(strings "$file_path" | grep -i 'appimage-version' | head -n 1 | awk '{print $2}')
elif [[ "$file_name" =~ \.snap$ ]]; then
    file_version=$(snap info "$file_path" 2>/dev/null | grep 'version:' | awk '{print $2}')
elif [[ "$file_name" =~ \.dmg$ ]]; then
    if command -v hdiutil >/dev/null 2>&1; then
        file_version=$(hdiutil info "$file_path" 2>/dev/null | grep 'System Version' | awk '{print $3}')
    fi
elif [[ "$file_name" =~ \.exe$ ]]; then
    if command -v exiftool >/dev/null 2>&1; then
        file_version=$(exiftool "$file_path" | grep -i -E 'Product Version|File Version' | awk -F': ' '{print $2}' | sed 's/^[[:space:]]*//' | head -n 1)
    fi
fi

# Determine Visibility and Lock status
file_visibility="Visible"
if [ ! -r "$file_path" ] || [ ! -x "$file_path" ]; then
    file_visibility="Invisible"
fi
file_lock_status="Unlocked"
if [ ! -w "$file_path" ]; then
    file_lock_status="Locked"
fi
file_status="$file_lock_status - $file_visibility"

# Display Information
info="File: $file_name\n"
info+="Path: $file_path\n\n"
info+="File Type: $file_type\n"
info+="MIME Type: $file_info\n"
info+="Encoding: $file_encoding\n"
info+="Size: $(retrieve_cache "formatted_size")\n"
info+="Owner: $file_owner\n"
info+="Permissions: $file_permissions\n"
info+="Status: $file_status\n\n"
info+="Version: ${file_version:-N/A}\n"
info+="Magic Number: ${file_magic_number:-N/A}\n"
info+="MD5 Hash: $(retrieve_cache "md5_hash")\n"
info+="SHA1 Hash: $(retrieve_cache "sha1_hash")\n"
info+="SHA256 Hash: $(retrieve_cache "sha256_hash")\n"
info+="CRC32 Checksum: $(retrieve_cache "crc32_checksum")\n"
info+="Encryption Status: $(retrieve_cache "encrypted_status")\n"
info+="Extended Attributes: $xattrs\n"
info+="Creation Date: $file_creation_date\n"
info+="Last Modification: $file_mod_time"

kdialog --title "Extended File Information" --msgbox "$info"

# Output debugging info
echo "Debugging information (terminal):" >&2
echo "Sample size: $sample_size" >&2
echo "Sample extracted: $(echo "$sample" | head -c 100)" >&2
echo "Entropy result: $entropy" >&2
