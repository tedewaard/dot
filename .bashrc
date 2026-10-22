#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


alias ls='ls --color=auto'

# Fix command history with tmux
shopt -s histappend           # append on exit instead of overwriting
HISTSIZE=100000               # in-memory entries
HISTFILESIZE=200000           # lines kept on disk
HISTCONTROL=ignoreboth        # drop dupes and space-prefixed commands
HISTTIMEFORMAT='%F %T '       # timestamps
PROMPT_COMMAND='history -a; history -n'   # flush to disk after every command

# Adding git branch to command prompt
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

parse_kube_config() {
    if [ -n "$KUBECONFIG" ]; then
        echo "[$(basename "$KUBECONFIG")]"
    fi
}

g(){
    files=$(find ~/repo -maxdepth 1 -mindepth 1 -type d; find ~/serepo -maxdepth 1 -mindepth 1 -type d; find ~/pptrepo -maxdepth 1 -mindepth 1 -type d)
    dir=$(echo "$files" | sort | fzf -1 -0 -q "$1")
    cd "$dir"
}

kc(){
    files=$(find ~/.kube -maxdepth 1 -mindepth 1 -type f)    
    file=$(echo "$files" | sort | fzf -1 -0 -q "$1")
    echo $file
    export KUBECONFIG=$file
}

# Easily select which field I want
field() {
	awk -F "${2:- }" "{ print \$${1:-1} }"
}

# Sum up a column of numbers
total() {
	awk -F "${2:- }" "{ s += \$${1:-1} } END { print s }"
}

#New PS1
#export PS1="\u@\h \[\e[32m\]\w \[\e[91m\]\$(parse_git_branch)\[\e[00m\]$ "
export PS1="\u@\h \[\e[32m\]\w \[\e[91m\]\$(parse_git_branch)\[\e[36m\]\$(parse_kube_config)\[\e[00m\]$ "


#Old PS1
#PS1='[\u@\h \W]\$ '

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias kcpu="kubectl get nodes -o custom-columns='NAME:.metadata.name,CPU:.status.capacity.cpu,MEMORY:.status.capacity.memory'"
alias mybd='bd list -a "Trevor Edewaard"'

# Flatpak aliases
alias telegram="flatpak run org.telegram.desktop & disown"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

alias f5='f5fpc --info'
alias :q='exit'
alias lm='xrandr --listmonitors'
alias uw='xrandr --output eDP-1 --off && xrandr --output HDMI-2 --mode "3440x1440" --scale ".75x.75"'
alias ss='systemctl suspend'
alias k='kubectl'
complete -o default -F __start_kubectl k
alias op='cd $(fd -t d | fzf) && nvim'
alias ts='tmux-sessionizer'


#Set bash to use vi keybindings
set -o vi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
. "$HOME/.cargo/env"

export PATH="/home/tedewaard/.local/bin/:$PATH"
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:~/go/bin
export PATH=$HOME/.elixir-install/installs/otp/28.1/bin:$PATH
export PATH=$HOME/.elixir-install/installs/elixir/1.19.0-otp-28/bin:$PATH

export BEADS_DIR="$HOME/serepo/issues/.beads"

export NVM_DIR="$HOME/.nvm"
# nvm runs `manpath` when MANPATH is unset; on WSL that scans /mnt/c and is slow (~700ms).
# An empty entry (":") tells man to still include the default system paths.
export MANPATH="${MANPATH:-:}"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
eval "$(zoxide init bash)"


# Cached shell completions (generating them on every start is slow).
# Missing cache files are created on first run. Run `refresh_completions`
# after you upgrade kubectl, flux or bd.
_completion_cache_dir="$HOME/.cache/bash-completions"
_cached_completion() {
    local cmd="$1" file="$_completion_cache_dir/$1.bash"
    if [ ! -s "$file" ] && command -v "$cmd" >/dev/null 2>&1; then
        mkdir -p "$_completion_cache_dir"
        "$cmd" completion bash > "$file" 2>/dev/null || rm -f "$file"
    fi
    [ -s "$file" ] && . "$file"
}
refresh_completions() {
    rm -f "$_completion_cache_dir"/{kubectl,flux,bd}.bash
    for c in kubectl flux bd; do _cached_completion "$c"; done
}

# opencode
export PATH=/home/tedewaard/.opencode/bin:$PATH

# npm global (user-writable)
export PATH="$HOME/.npm-global/bin:$PATH"

# Added by flyctl installer
export FLYCTL_INSTALL="/home/tedewaard/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"



# Log in to an Azure Container Registry using a short-lived Entra token.
# Usage: acr-login <registry-name>   (name only, not the full .azurecr.io FQDN)
acr-login() {
  local registry="$1"

  if [ -z "$registry" ]; then
    echo "Usage: acr-login <registry-name>" >&2
    return 1
  fi

  # Ensure az is present and we have an active Azure session.
  if ! command -v az >/dev/null 2>&1; then
    echo "acr-login: 'az' CLI not found on PATH" >&2
    return 1
  fi
  if ! az account show >/dev/null 2>&1; then
    echo "acr-login: not logged in to Azure — run 'az login' first" >&2
    return 1
  fi

  local token
  token=$(az acr login --name "$registry" --expose-token --output tsv --query accessToken) || {
    echo "acr-login: failed to obtain token for '$registry'" >&2
    return 1
  }

  echo "$token" | podman login "${registry}.azurecr.io" \
    --username 00000000-0000-0000-0000-000000000000 \
    --password-stdin
}

#atuin
. "$HOME/.atuin/bin/env"
eval "$(atuin init bash)"

#Fix for WSL on PPT laptop
export NODE_EXTRA_CA_CERTS=/usr/local/share/ca-certificates/cisco-umbrella-root.crt

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

# Load completions last so every tool is on PATH.
for _c in kubectl flux bd; do _cached_completion "$_c"; done
unset _c
