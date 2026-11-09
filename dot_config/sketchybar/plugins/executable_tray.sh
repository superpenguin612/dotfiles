#!/bin/bash
# D68: a click rebuilds the popup from the menu bar's current items (apps come and go), then
# opens it; leaving the bar and popup closes it. Aliases need Screen Recording for SketchyBar.
if [ "$SENDER" = mouse.exited.global ]; then
  sketchybar --set "$NAME" popup.drawing=off
  exit 0
fi
[ "$SENDER" = mouse.clicked ] || exit 0
if [ "$(sketchybar --query "$NAME" | /usr/bin/jq -r .popup.drawing)" = on ]; then
  sketchybar --set "$NAME" popup.drawing=off
  exit 0
fi
while read -r old; do
  [ -n "$old" ] && sketchybar --remove "$old"
done < <(sketchybar --query "$NAME" | /usr/bin/jq -r '.popup.items[]?')
while read -r item; do
  case $item in
    # The bar shows these itself.
    "Control Center,Clock" | "Control Center,Battery" | "Control Center,WiFi" | "Control Center,Sound") continue ;;
  esac
  sketchybar --add alias "$item" "popup.$NAME" \
    --set "$item" background.drawing=off icon.drawing=off label.drawing=off padding_left=0 padding_right=0
done < <(sketchybar --query default_menu_items | /usr/bin/jq -r '.[]')
sketchybar --set "$NAME" popup.drawing=on
