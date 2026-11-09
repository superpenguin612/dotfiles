#!/bin/bash
# volume_change: $INFO is the volume, 0 to 100.
[ "$SENDER" = volume_change ] || exit 0
case $INFO in
  [6-9][0-9] | 100) icon= ;;
  [1-5][0-9] | [1-9]) icon= ;;
  *) icon= ;;
esac
sketchybar --set "$NAME" icon="$icon" label="$INFO%"
