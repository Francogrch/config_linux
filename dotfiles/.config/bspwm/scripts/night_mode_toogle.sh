#!/bin/bash

# Define the state file
STATE_FILE="/tmp/night_mode_state"

# Check the current state
if [ ! -f "$STATE_FILE" ] || [ "$(cat "$STATE_FILE")" == "off" ]; then
  # Night mode is OFF, so turn it ON
  redshift -O 4500 &
  echo "on" >"$STATE_FILE"
  dunstify "Night Mode" "Activated"
else
  # Night mode is ON, so turn it OFF
  redshift -x
  echo "off" >"$STATE_FILE"
  dunstify "Night Mode" "Deactivated"
fi
