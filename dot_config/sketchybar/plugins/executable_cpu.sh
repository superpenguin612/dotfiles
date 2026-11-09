#!/bin/bash
# CPU use across all cores, and memory in use (100 minus memory_pressure's free percentage).
cpu=$(ps -A -o %cpu= | awk -v n="$(sysctl -n hw.ncpu)" '{s += $1} END {printf "%d", s / n}')
mem=$(memory_pressure | awk '/free percentage/ {sub("%", "", $5); print 100 - $5}')
sketchybar --set "$NAME" label="$cpu%  $mem%"
