#!/usr/bin/env bash
#
# bootstrap.sh — one-liner entry point for installing dotfiles.
#
#   curl -fsSL https://raw.githubusercontent.com/tedewaard/dot/main/bootstrap.sh | bash
#
# What it does:
#   1. Clones (or pulls) the dotfiles repo to ~/repo/dot
#   2. Hands off to install.sh inside the repo, which does the actual symlinking
#
# This script intentionally stays tiny: it only gets the repo onto disk so that
# install.sh (which locates the dotfiles via BASH_SOURCE) can run correctly.
#
set -euo pipefail

# ----------------------------------------------------------------------------
# CONFIGURATION
# ----------------------------------------------------------------------------
readonly REPO_URL="https://github.com/tedewaard/dot.git"
readonly REPO_BRANCH="main"
readonly DOTFILES_DIR="$HOME/repo/dot"

# ----------------------------------------------------------------------------
# PRETTY PRINTING (minimal — install.sh does the fancy UI)
# ----------------------------------------------------------------------------
fmt_bold='\033[1m'; fmt_blue='\033[0;34m'; fmt_green='\033[0;32m'
fmt_red='\033[0;31m'; fmt_yellow='\033[1;33m'; fmt_reset='\033[0m'

# Respect NO_COLOR (https://no-color.org/)
if [ -n "${NO_COLOR:-}" ] || [ ! -t 1 ]; then
    fmt_bold=''; fmt_blue=''; fmt_green=''; fmt_red=''; fmt_yellow=''; fmt_reset=''
fi

log()  { printf "${fmt_bold}${fmt_blue}==>${fmt_reset} ${fmt_bold}%s${fmt_reset}\n" "$*"; }
ok()   { printf "${fmt_green}  ✓${fmt_reset} %s\n" "$*"; }
warn() { printf "${fmt_yellow}  !${fmt_reset} %s\n" "$*"; }
err()  { printf "${fmt_red}  ✗${fmt_reset} %s\n" "$*" >&2; }

# ----------------------------------------------------------------------------
# SANITY CHECKS
# ----------------------------------------------------------------------------
need() {
    if ! command -v "$1" >/dev/null 2>&1; then
        err "Required command not found: $1"
        err "Please install it and re-run:"
        case "$1" in
            git) err "  https://git-scm.com/downloads" ;;
        esac
        exit 1
    fi
}

need git

# ----------------------------------------------------------------------------
# GET THE REPO ONTO DISK
# ----------------------------------------------------------------------------
log "Dotfiles target: ${DOTFILES_DIR/#$HOME/~}"

if [ -d "$DOTFILES_DIR/.git" ]; then
    # Existing checkout — update it.
    log "Existing checkout found, pulling latest..."
    git -C "$DOTFILES_DIR" fetch --quiet origin "$REPO_BRANCH"
    git -C "$DOTFILES_DIR" checkout --quiet "$REPO_BRANCH"
    git -C "$DOTFILES_DIR" reset --quiet --hard "origin/$REPO_BRANCH"
    ok "Updated to latest."
else
    if [ -e "$DOTFILES_DIR" ]; then
        warn "$DOTFILES_DIR exists but is not a git repository."
        err "Refusing to overwrite. Please move/remove it and re-run."
        exit 1
    fi

    log "Cloning $REPO_URL ..."
    if ! git clone --branch "$REPO_BRANCH" --quiet "$REPO_URL" "$DOTFILES_DIR"; then
        err "git clone failed."
        err "Check your network connection and that the repo exists: $REPO_URL"
        exit 1
    fi
    ok "Cloned."
fi

# ----------------------------------------------------------------------------
# HAND OFF TO install.sh
# ----------------------------------------------------------------------------
log "Running install.sh ..."
# Run install.sh in its own directory so its BASH_SOURCE logic is happy.
# exec replaces this process with install.sh, so any further bootstrap code
# below would not run — but there is none by design.
cd "$DOTFILES_DIR"
exec ./install.sh "$@"
