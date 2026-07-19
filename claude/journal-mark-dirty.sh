#!/usr/bin/env bash
# PostToolUse (Write|Edit|Bash) hook: mark that unlogged work happened this session.
# - Write|Edit: arm unless the edit is to the journal itself (so writing the
#   journal doesn't re-arm the nudge).
# - Bash: arm on any command (covers investigation-only turns that produce a
#   conclusion but no file edit).
# Never fails the tool — always exits 0.
input=$(cat)
tool=$(printf '%s' "$input" | jq -r '.tool_name // empty' 2>/dev/null)

case "$tool" in
  Bash)
    touch "$HOME/.memory/.unlogged" 2>/dev/null
    ;;
  Write|Edit)
    f=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
    if [ -n "$f" ] && [[ "$f" != "$HOME/.memory/"* ]]; then
      touch "$HOME/.memory/.unlogged" 2>/dev/null
    fi
    ;;
esac
exit 0
