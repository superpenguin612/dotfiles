#!/bin/bash
# Switch to Space $1 through the "Switch to Desktop N" shortcuts (^1 to ^9), which must be turned
# on in System Settings → Keyboard → Keyboard Shortcuts → Mission Control.
codes=(0 18 19 20 21 23 22 26 28 25)
osascript -e "tell application \"System Events\" to key code ${codes[$1]} using control down"
