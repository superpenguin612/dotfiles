#!/bin/bash
# Connected or not; the network name needs Location Services, so it isn't shown.
source "$CONFIG_DIR/colors.sh"
if [ -n "$(ipconfig getifaddr en0)" ]; then
  sketchybar --set "$NAME" icon= icon.color=$BLUE
else
  sketchybar --set "$NAME" icon=󰖪 icon.color=$COMMENT
fi
