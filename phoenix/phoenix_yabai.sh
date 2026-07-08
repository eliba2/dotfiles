#!/usr/bin/env bash
set -euo pipefail

# Focus/cycle app windows and move window between displays using yabai.
# Requires: yabai, jq, skhd (for keybindings)

focus_or_cycle_app() {
  local app="$1"
  local apps_json
  apps_json=$(yabai -m query --windows | jq -c --arg app "$app" '[.[] | select(.app == $app and .minimized == 0)]')
  local count
  count=$(echo "$apps_json" | jq 'length')
  if [[ "$count" -eq 0 ]]; then
    open -a "$app"
    exit 0
  fi

  local focused_id
  focused_id=$(echo "$apps_json" | jq -r 'map(select(.focused == 1)) | .[0].id // empty')
  if [[ -z "$focused_id" ]]; then
    local last_id
    last_id=$(echo "$apps_json" | jq -r '.[-1].id')
    yabai -m window --focus "$last_id"
    exit 0
  fi

  local ids
  ids=($(echo "$apps_json" | jq -r '.[].id'))
  local idx=0
  local i
  for i in "${!ids[@]}"; do
    if [[ "${ids[$i]}" == "$focused_id" ]]; then
      idx=$i
      break
    fi
  done
  local next_idx=$(( (idx - 1 + ${#ids[@]}) % ${#ids[@]} ))
  yabai -m window --focus "${ids[$next_idx]}"
}

move_window_display() {
  local direction="$1"
  local focused
  focused=$(yabai -m query --windows --window | jq -r '.id // empty')
  if [[ -z "$focused" ]]; then
    exit 0
  fi
  yabai -m window --display "$direction"
  yabai -m display --focus "$direction"
}

case "${1:-}" in
  cycle-app)
    focus_or_cycle_app "$2"
    ;;
  move-left)
    move_window_display west
    ;;
  move-right)
    move_window_display east
    ;;
  maximize)
    yabai -m window --toggle zoom-fullscreen
    ;;
  *)
    echo "Usage: $0 cycle-app <AppName> | move-left | move-right | maximize"
    exit 1
    ;;
esac
