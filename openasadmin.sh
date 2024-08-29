#!/bin/bash
# Open folder with elevated privileges
pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR dolphin "$1"
