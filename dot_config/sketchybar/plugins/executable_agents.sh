#!/bin/bash
# Agents waiting on me on the dev VM (agent-ping's counts), over SSH. Hidden when nothing waits;
# grey when unreachable. ClearAllForwardings: without it each check would take over the
# RemoteForward clipboard socket (~/.clip.sock) from the interactive session, then drop it.
source "$CONFIG_DIR/colors.sh"
out=$(/usr/bin/ssh -o BatchMode=yes -o ConnectTimeout=3 -o ClearAllForwardings=yes "${DEV_HOST:-devserver}" \
  'tmux show -gqv @agents_asking; tmux show -gqv @agents_waiting' 2>/dev/null) || {
  sketchybar --set "$NAME" drawing=on icon=󰚩 icon.color=$COMMENT label="–" label.color=$COMMENT
  exit 0
}
{ read -r asking; read -r waiting; } <<<"$out"
asking=${asking:-0} waiting=${waiting:-0}
if [ "$asking" -gt 0 ]; then
  label="? $asking" color=$RED
  [ "$waiting" -gt 0 ] && label+="  ● $waiting"
elif [ "$waiting" -gt 0 ]; then
  label="● $waiting" color=$YELLOW
else
  sketchybar --set "$NAME" drawing=off
  exit 0
fi
sketchybar --set "$NAME" drawing=on icon=󰚩 icon.color=$color label="$label" label.color=$color
