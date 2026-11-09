#!/bin/bash
# space_windows_change: $INFO is {"space": N, "apps": {"Firefox": 2, ...}}.
[ "$SENDER" = space_windows_change ] || exit 0
source "$CONFIG_DIR/icon_map.sh"
space=$(/usr/bin/jq -r .space <<<"$INFO")
icons=""
while read -r app; do
  [ -n "$app" ] || continue
  __icon_map "$app"
  icons+=" $icon_result"
done < <(/usr/bin/jq -r '.apps | keys[]' <<<"$INFO")
icons=${icons# }
sketchybar --set "space.$space" label="$icons" label.drawing="$([ -n "$icons" ] && echo on || echo off)"
