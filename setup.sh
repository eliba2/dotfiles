#!/bin/bash

# Opt-in flags (default off). Usage: ./setup.sh [--claude]
#   --claude   also set up the Claude Code daily work-journal mechanism
SETUP_CLAUDE=0
for arg in "$@"; do
  case "$arg" in
    --claude) SETUP_CLAUDE=1 ;;
    *) echo "Unknown option: $arg (supported: --claude)" >&2 ;;
  esac
done

# vim
ln -s ${HOME}/.dotfiles/vim/.vimrc ${HOME}/.vimrc
ln -s ${HOME}/.dotfiles/vim/.gvimrc ${HOME}/.gvimrc

# nvim
ln -s ${HOME}/.dotfiles/neovim/init.vim ${HOME}/.config/nvim/init.vim
ln -s ${HOME}/.dotfiles/neovim/ginit.vim ${HOME}/.config/nvim/ginit.vim
ln -s ${HOME}/.dotfiles/neovim/lua ${HOME}/.config/nvim/lua

# kitty
# note: pager uses lua script which is linked in lua above
ln -s ${HOME}/.dotfiles/kitty/kitty.conf ${HOME}/.config/kitty/kitty.conf

# phoenix (osx only, https://kasper.github.io/phoenix/)
ln -s ${HOME}/.dotfiles/phoenix/phoenix.js ${HOME}/.phoenix.js

# yazi
mkdir -p ${HOME}/.config/yazi
ln -s ${HOME}/.dotfiles/yazi/yazi.toml    ${HOME}/.config/yazi/yazi.toml
ln -s ${HOME}/.dotfiles/yazi/keymap.toml  ${HOME}/.config/yazi/keymap.toml
ln -s ${HOME}/.dotfiles/yazi/init.lua     ${HOME}/.config/yazi/init.lua
ln -s ${HOME}/.dotfiles/yazi/package.toml ${HOME}/.config/yazi/package.toml

# yazi plugins. Two sources:
#  1. vendored here (not installable from a registry) — see yazi/plugins/README.md
#  2. package.toml (bookmarks / glow / starship) — restored by `ya pkg install` below
mkdir -p ${HOME}/.config/yazi/plugins
for p in jump worktrees confirm-quit; do
  ln -s ${HOME}/.dotfiles/yazi/plugins/${p}.yazi ${HOME}/.config/yazi/plugins/${p}.yazi
done
if command -v ya >/dev/null 2>&1; then
  ya pkg install
else
  echo "yazi not installed yet; run 'ya pkg install' after installing it."
fi

# yazi floating-window theme home (rose-pine-dawn flavor; used by Phoenix Cmd-Y via
# YAZI_CONFIG_HOME=~/.config/yazi-float). Reuses the main yazi config via symlinks.
mkdir -p ${HOME}/.config/yazi-float/flavors
ln -s ${HOME}/.config/yazi/init.lua     ${HOME}/.config/yazi-float/init.lua
ln -s ${HOME}/.config/yazi/keymap.toml  ${HOME}/.config/yazi-float/keymap.toml
ln -s ${HOME}/.config/yazi/package.toml ${HOME}/.config/yazi-float/package.toml
ln -s ${HOME}/.config/yazi/yazi.toml    ${HOME}/.config/yazi-float/yazi.toml
ln -s ${HOME}/.config/yazi/plugins      ${HOME}/.config/yazi-float/plugins
ln -s ${HOME}/.dotfiles/yazi/float-theme.toml ${HOME}/.config/yazi-float/theme.toml
# flavor (re-clone):
#   git clone https://github.com/Mintass/rose-pine-dawn.yazi ${HOME}/.config/yazi-float/flavors/rose-pine-dawn.yazi
# (the floating kitty config + icon live in ~/.dotfiles/kitty/yazi-float and are
#  referenced directly by phoenix.js, so they need no symlink.)

# rclone (S3 remote; uses env_auth so no keys are stored here)
mkdir -p ${HOME}/.config/rclone
ln -s ${HOME}/.dotfiles/rclone/rclone.conf ${HOME}/.config/rclone/rclone.conf

# visidata (custom keybindings)
ln -s ${HOME}/.dotfiles/visidata/.visidatarc ${HOME}/.visidatarc

# claude — daily work-journal mechanism (~/.memory/). Opt-in via --claude, since
# not every machine runs AI. The installer is idempotent: it symlinks the hook
# scripts and MERGES the settings.json hooks + CLAUDE.md section (those files also
# hold machine-specific content, so they aren't symlinked). Journal content in
# ~/.memory/ stays local per-machine — not tracked here.
if [ "$SETUP_CLAUDE" -eq 1 ]; then
  bash ${HOME}/.dotfiles/claude/install-journal.sh
else
  echo "Skipping Claude daily-journal setup (pass --claude to enable)."
fi
