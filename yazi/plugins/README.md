# Vendored yazi plugins

These plugins are checked into this repo (rather than restored by `ya pkg install`)
because they are not installable from a package registry. `setup.sh` symlinks each
of them into `~/.config/yazi/plugins/`.

| Plugin | Origin | Why vendored |
|---|---|---|
| `jump.yazi` | written locally (Eli) | never published; browser-style back/forward through visited directories (`<C-o>` / `<C-I>`) plus 5-entry cursor jumps (`<C-j>` / `<C-k>`) |
| `worktrees.yazi` | written locally (Eli) | never published; lists/removes git worktrees via an fzf multi-select overlay (`\` then `w`) |
| `confirm-quit.yazi` | upstream `yazi-rs/plugins` (MIT) | **removed from upstream** — `ya pkg add yazi-rs/plugins:confirm-quit` now fails, so the last-known-good copy is kept here. Bound to `q`. |

Plugins that *are* still installable live in `../package.toml` and are restored with:

```sh
ya pkg install
```

That currently covers `dedukun/bookmarks`, `Reledia/glow` and `Rolv-Apneseth/starship`.

The original standalone git repos for `jump.yazi` and `worktrees.yazi` (with their own
commit history) were developed under `~/Tests/`; the copies here are now the source of
truth, so edit these.
