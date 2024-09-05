#!/bin/bash

# Check file
if [ -z "$1" ]; then
    echo "No file provided. Usage: runasadmin.sh <file>"
    exit 1
fi

FILE="$1"

# File exists?
if [ ! -f "$FILE" ]; then
    echo "File does not exist: $FILE"
    exit 1
fi

# Run file as admin, preserve environment, keep the terminal open
sudo -E bash "$FILE"; exec bash
