#!/bin/bash
# volume_change gives the volume (0 to 100) in $INFO; at startup it is read from the system.
vol=$INFO
[ "$SENDER" = volume_change ] || vol=$(osascript -e 'output volume of (get volume settings)')
INFO=$vol
case $INFO in
  [6-9][0-9] | 100) icon= ;;
  [1-5][0-9] | [1-9]) icon= ;;
  *) icon= ;;
esac
sketchybar --set "$NAME" icon="$icon" label="$INFO%"
