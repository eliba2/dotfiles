# dotfiles

Personal (mostly macOS) dotfiles, deployed via symlinks with `setup.sh`.

## Install

```sh
git clone git@github.com:eliba2/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git submodule update --init      # kitty_search
./setup.sh                       # symlink configs into place
```

## Migrating an existing machine (Bitbucket → GitHub)

If a machine still has `~/.dotfiles` pointed at the old Bitbucket remote, repoint it
at GitHub and reconcile. First make sure the machine can reach the private repo
(`ssh -T git@github.com`, or run `gh auth login`). Then:

```sh
cd ~/.dotfiles
git remote rename origin bitbucket                       # keep old as backup (optional)
git remote add origin git@github.com:eliba2/dotfiles.git # or: git remote set-url origin ...
git fetch origin

git log --oneline origin/master..master                  # LOCAL commits not on GitHub
```

- No local-only commits → `git pull --ff-only origin master`
- Has unpushed local commits → `git pull --rebase origin master` (resolve, then `git push origin master`)
- Don't need this machine's state → `git reset --hard origin/master`

Then:

```sh
git submodule update --init
git branch --set-upstream-to=origin/master master
```

Since Bitbucket went read-only, those machines likely have unpushed commits — prefer
the `--rebase` path so nothing is lost.

## What's here

- **vim / neovim** — `.vimrc`, `.gvimrc`, `init.vim`, `ginit.vim`, `lua/`
- **kitty** — `kitty.conf`; `yazi-float/` (dedicated config + dock icon for the floating yazi window); `kitty_search` (submodule)
- **phoenix** — `phoenix.js` (macOS window management + `Cmd-Y` floating-yazi launcher); `phoenix_yabai.sh` + `phoenix_skhdrc` (an alternative yabai/skhd port of the same bindings)
- **yazi** — `yazi.toml`, `keymap.toml`, `init.lua`, `package.toml`, `float-theme.toml`
- **rclone** — `rclone.conf` (S3 remote via `env_auth`; no keys stored)

## Not tracked — reinstall after `setup.sh`

- **yazi plugins:** `ya pkg install` (bookmarks / glow / starship). `jump.yazi` & `worktrees.yazi` are local-only — copy them into `~/Tests/` and symlink into `~/.config/yazi/plugins/`.
- **floating yazi theme:** `git clone https://github.com/Mintass/rose-pine-dawn.yazi ~/.config/yazi-float/flavors/rose-pine-dawn.yazi`
- **tools:** nvim, yazi, rclone (official build, not Homebrew's — the Homebrew build disables `mount`), node (via nvm).

Primarily macOS — Phoenix, the kitty app icon, and the `open`-based launchers are macOS-specific.
