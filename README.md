# dot

My personal dotfiles — bash, tmux, nvim, helix, awesomewm, and a few X bits.
Everything is symlinked into place from a single checkout, so the repo *is* the
live config: edit a file here and it's immediately active.

## Install (one-liner)

On a fresh machine:

```bash
curl -fsSL https://raw.githubusercontent.com/tedewaard/dot/main/bootstrap.sh | bash
```

This clones the repo to `~/repo/dot` and runs [`install.sh`](install.sh), which
symlinks everything into your `$HOME` and `~/.config`. Re-running the same
command later pulls the latest and re-syncs — it's idempotent, so it's also how
you **update** an existing machine after pushing changes.

> Existing files at the symlink targets are backed up with a `.bak.<timestamp>`
> suffix before being replaced, so nothing gets clobbered silently.

## What gets linked

| Source (in repo)        | Target                |
| ----------------------- | --------------------- |
| `.bashrc`               | `~/.bashrc`           |
| `.profile`              | `~/.profile`          |
| `.tmux.conf`            | `~/.tmux.conf`        |
| `.xinitrc`              | `~/.xinitrc`          |
| `.xprofile`             | `~/.xprofile`         |
| `nvim/`                 | `~/.config/nvim`      |
| `helix/`                | `~/.config/helix`     |
| `awesomewm/`            | `~/.config/awesome`   |
| `tmux-sessionizer/`     | `~/.config/tmux-sessionizer` |

`install.sh` also clones [TPM](https://github.com/tmux-plugins/tpm) (Tmux Plugin
Manager) into `~/.tmux/plugins/tpm` if it isn't there already.

## Post-install

1. Reload your shell: `source ~/.bashrc` (or restart your terminal).
2. Open tmux and press `Ctrl-A` then `I` to install tmux plugins via TPM.

## How it works

- [`bootstrap.sh`](bootstrap.sh) — tiny network entry point. Gets the repo onto
  disk, then `exec`s `install.sh`. Exists because `install.sh` locates the
  dotfiles via `BASH_SOURCE`, which doesn't work when piped straight over the
  network. Same pattern Homebrew / oh-my-zsh / nvm use.
- [`install.sh`](install.sh) — does the actual work: symlink home files,
  symlink `~/.config` directories, symlink pi agent config into `~/.pi/agent/`,
  install TPM, verify everything holds. Safe to run repeatedly.
- [`pi/`](pi/) — config for the pi coding agent. Only hand-written config lives
  here (`settings.json`, `extensions/` for custom extensions, and later
  `AGENTS.md`, `keybindings.json`, themes, etc.). Packages added via
  `pi install` are declared in `settings.json` (tracked) but download into
  `~/.pi/agent/npm|git/` (untracked) and reinstall automatically on new machines; `~/.pi/agent/` itself stays a real directory because pi writes runtime
  state there (`auth.json` secrets, `sessions/`, `bin/`, `models-store.json`).

If you've already cloned the repo manually you can skip the bootstrap and just
run `./install.sh` directly.

## Manual clone

If you'd rather not pipe to bash:

```bash
git clone https://github.com/tedewaard/dot.git ~/repo/dot
cd ~/repo/dot
./install.sh
```
