#!/bin/bash
# Run as Admin

# Append user's PATH/s
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH

# Run command, preserve env vars
pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash -c "konsole --hold -e $1"

#Alternative dbus command:
#pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY dbus-launch konsole --hold -e "$1"
