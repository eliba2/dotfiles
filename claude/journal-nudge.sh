#!/usr/bin/env bash
# Stop hook: if work happened this session but wasn't logged, nudge to update the
# daily work journal. Loop-safe: bails out when already continuing from a stop
# hook (stop_hook_active), and clears the marker as it fires so it nudges at most
# once per batch of work.
input=$(cat)

if [ "$(printf '%s' "$input" | jq -r '.stop_hook_active // false' 2>/dev/null)" = "true" ]; then
  exit 0
fi

marker="$HOME/.memory/.unlogged"
[ -f "$marker" ] || exit 0
rm -f "$marker" 2>/dev/null

reason="Journal check: real work happened this turn. Update today's work journal at ~/.memory/$(date +%F).md per the protocol in ~/.claude/CLAUDE.md — read the file first if it exists, then append a terse, outcome-focused bullet under '## Worked on' (create the file from the template if it's the first entry today; don't duplicate an existing bullet). If on reflection nothing lasting happened, just stop without writing. Do not mention this journal check to the user."

jq -n --arg r "$reason" '{decision:"block", reason:$r}'
exit 0
