#!/bin/bash
# The current Space's pill is highlighted.
source "$CONFIG_DIR/colors.sh"
if [ "$SELECTED" = true ]; then
  sketchybar --set "$NAME" background.color=$BG_HL background.border_color=$BLUE icon.color=$BLUE
else
  sketchybar --set "$NAME" background.color=$BG background.border_color=$BG_HL icon.color=$COMMENT
fi
