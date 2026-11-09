#!/bin/bash
# The next timed event today (icalBuddy asks for Calendar access the first time).
ev=$(/opt/homebrew/bin/icalBuddy -n -nc -ea -li 1 -b '' -nrd -df '' -tf '%H:%M' \
  -iep title,datetime -ps '| · |' eventsToday 2>/dev/null | head -n1)
if [ -n "$ev" ]; then
  [ ${#ev} -gt 40 ] && ev="${ev:0:39}…"
  sketchybar --set "$NAME" drawing=on label="$ev"
else
  sketchybar --set "$NAME" drawing=off
fi
