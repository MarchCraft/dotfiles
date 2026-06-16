#!/usr/bin/env bash
#
# Show next calendar event for waybar (CalDAV via khal)
#

set -euo pipefail

if ! command -v khal &>/dev/null; then
  echo "Please install khal (CalDAV frontend for vdirsyncer)"
  exit 1
fi

# Get next events (today onward, TSV-like output)
events=$(khal list now 7d --format "{start}\t{end}\t{title}" 2>/dev/null | head -n 1)

if [[ -z "$events" ]]; then
  echo '{"text": "No events", "tooltip": ""}'
  exit 0
fi

start_raw=$(echo "$events" | cut -f1)
end_raw=$(echo "$events" | cut -f2)
event=$(echo "$events" | cut -f3)

start_date=$(date +"%s" -d "$start_raw")
end_date=$(date +"%s" -d "$end_raw")
current_date=$(date +"%s")

text=""

if [[ $((start_date - current_date)) -gt 0 ]]; then
  diff=$((start_date - current_date))
  hours=$((diff / 3600))
  minutes=$(((diff % 3600) / 60))

  if [[ $hours -eq 0 ]]; then
    text="$event starts in $minutes minutes"
  else
    text="$event starts in $hours hours and $minutes minutes"
  fi
else
  diff=$((end_date - current_date))
  hours=$((diff / 3600))
  minutes=$(((diff % 3600) / 60))

  if [[ $hours -eq 0 ]]; then
    text="$event ends in $minutes minutes"
  else
    text="$event ends in $hours hours and $minutes minutes"
  fi
fi

case "${1:-}" in
  open)
    xdg-open "https://calendar.google.com"  # fallback web view
    ;;
  waybar)
    cat <<EOF
{"text": "$text", "tooltip": "$event"}
EOF
    ;;
  *)
    echo "$text"
    ;;
esac
