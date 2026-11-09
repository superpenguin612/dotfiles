#!/bin/bash
# front_app_switched: $INFO is the app's name.
[ "$SENDER" = front_app_switched ] || exit 0
source "$CONFIG_DIR/icon_map.sh"
__icon_map "$INFO"
sketchybar --set "$NAME" icon="$icon_result" label="$INFO"
