#!/usr/bin/env bash
# Installs the daily work-journal mechanism into ~/.claude on this machine.
# Idempotent — safe to re-run. Called by ../setup.sh, or run directly.
#
# The hook SCRIPTS are symlinked from this dir (single source of truth).
# The settings.json hooks block and the CLAUDE.md section are MERGED, not
# symlinked, because those files also hold machine-specific content.
#
# Installs the mechanism only — journal content in ~/.memory/ stays local.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
HOOKS_DIR="$CLAUDE_DIR/hooks"
SETTINGS="$CLAUDE_DIR/settings.json"
CLAUDEMD="$CLAUDE_DIR/CLAUDE.md"
SNIPPET="$DIR/CLAUDE.journal.md"

command -v jq >/dev/null 2>&1 || { echo "ERROR: jq is required (brew install jq / apt install jq)"; exit 1; }

mkdir -p "$HOME/.memory" "$HOOKS_DIR"

# 1) symlink hook scripts (single source of truth in the dotfiles repo)
ln -sf "$DIR/journal-mark-dirty.sh" "$HOOKS_DIR/journal-mark-dirty.sh"
ln -sf "$DIR/journal-nudge.sh"      "$HOOKS_DIR/journal-nudge.sh"
echo "✓ hook scripts symlinked into $HOOKS_DIR"

# 2) merge hooks into settings.json (preserves other settings; no duplicates)
[ -s "$SETTINGS" ] || echo '{}' > "$SETTINGS"
tmp=$(mktemp)
jq '
  .hooks.PostToolUse = ((.hooks.PostToolUse // [])
      | map(select((.hooks // []) | any(.command == "~/.claude/hooks/journal-mark-dirty.sh") | not)))
      + [{matcher:"Write|Edit|Bash", hooks:[{type:"command", command:"~/.claude/hooks/journal-mark-dirty.sh"}]}]
  | .hooks.Stop = ((.hooks.Stop // [])
      | map(select((.hooks // []) | any(.command == "~/.claude/hooks/journal-nudge.sh") | not)))
      + [{hooks:[{type:"command", command:"~/.claude/hooks/journal-nudge.sh"}]}]
' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
echo "✓ hooks merged into $SETTINGS"

# 3) append the CLAUDE.md protocol section (once)
touch "$CLAUDEMD"
if grep -q "^# Daily work journal" "$CLAUDEMD"; then
  echo "• CLAUDE.md section already present — left as-is"
else
  printf '\n' >> "$CLAUDEMD"
  cat "$SNIPPET" >> "$CLAUDEMD"
  echo "✓ appended Daily work journal section to $CLAUDEMD"
fi

echo
echo "Done. Open a NEW Claude Code session (or run /hooks) for the hooks to take effect."
echo "Journal lives at ~/.memory/ on THIS machine only."
