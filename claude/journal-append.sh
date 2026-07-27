#!/usr/bin/env bash
# Quietly append a bullet to today's work journal under "## Worked on".
# Bullet text comes from "$1" (or stdin). Creates today's file from the template
# on first use. Prints ONLY "Updated journal" so the terminal stays quiet — the
# bullet text is never echoed back.
set -euo pipefail

today=$(date +%F)
f="$HOME/.memory/$today.md"
mkdir -p "$HOME/.memory"

bullet="${1:-$(cat)}"
bullet="${bullet#- }"   # tolerate a leading "- " if passed

if [ ! -f "$f" ]; then
  {
    printf '# %s\n\n' "$today"
    printf '## Summary\n%s\n\n' "$bullet"
    printf '## Worked on\n- %s\n\n' "$bullet"
    printf '## Open threads\n'
  } > "$f"
  echo "Updated journal"
  exit 0
fi

# Insert the bullet after the last non-blank line of the "## Worked on" section
# (keeps chronological order and preserves the blank line before the next heading).
tmp=$(mktemp)
awk -v b="- $bullet" '
  { lines[NR]=$0 }
  /^## Worked on[[:space:]]*$/ { ws=NR }
  END {
    if (ws==0) { for (i=1;i<=NR;i++) print lines[i]; print "## Worked on"; print b; exit }
    ni=NR+1
    for (i=ws+1;i<=NR;i++) if (lines[i] ~ /^## /) { ni=i; break }
    ip=ws
    for (i=ws+1;i<ni;i++) if (lines[i] !~ /^[[:space:]]*$/) ip=i
    for (i=1;i<=NR;i++) { print lines[i]; if (i==ip) print b }
  }
' "$f" > "$tmp" && mv "$tmp" "$f"

echo "Updated journal"
