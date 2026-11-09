#!/bin/bash
# The current Space's pill is highlighted.
source "$CONFIG_DIR/colors.sh"
if [ "$SELECTED" = true ]; then
  sketchybar --set "$NAME" background.drawing=on icon.color=$BLUE label.color=$FG
else
  sketchybar --set "$NAME" background.drawing=off icon.color=$COMMENT label.color=$COMMENT
fi
