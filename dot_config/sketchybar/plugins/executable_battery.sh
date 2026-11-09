#!/bin/bash
source "$CONFIG_DIR/colors.sh"
b=$(pmset -g batt)
pct=$(grep -Eo '[0-9]+%' <<<"$b" | tr -d %)
[ -n "$pct" ] || { sketchybar --set "$NAME" drawing=off; exit 0; }
case $pct in
  9[0-9] | 100) icon= color=$GREEN ;;
  [6-8][0-9]) icon= color=$GREEN ;;
  [3-5][0-9]) icon= color=$YELLOW ;;
  [1-2][0-9]) icon= color=$ORANGE ;;
  *) icon= color=$RED ;;
esac
grep -q 'AC Power' <<<"$b" && icon= color=$GREEN
sketchybar --set "$NAME" drawing=on icon="$icon" icon.color=$color label="$pct%"
