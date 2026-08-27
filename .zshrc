#
# ~/.zshrc
#

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return ;;
esac

alias ls='ls --color=auto'

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

# Prompt (zsh-native equivalent of the bash PS1)
setopt PROMPT_SUBST
PROMPT='%n@%m %F{green}%~%f %F{red}$(parse_git_branch)%f%F{cyan}$(parse_kube_config)%f$ '

# don't put duplicate lines or lines starting with space in the history.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt APPEND_HISTORY

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    precmd() { print -Pn "\e]0;%n@%m: %~\a" }
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

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

# Flatpak aliases
alias telegram="flatpak run org.telegram.desktop & disown"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.zsh_aliases, instead of adding them here directly.

if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

alias f5='f5fpc --info'
alias :q='exit'
alias lm='xrandr --listmonitors'
alias uw='xrandr --output eDP-1 --off && xrandr --output HDMI-2 --mode "3440x1440" --scale ".75x.75"'
alias ss='systemctl suspend'
alias k='kubectl'
alias op='cd $(fd -t d | fzf) && nvim'
alias ts='tmux-sessionizer'

# Set zsh to use vi keybindings
set -o vi

# Completion system
autoload -Uz compinit && compinit
compdef k=kubectl

if [ -s "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

export PATH="$HOME/.local/bin/:$PATH"
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:~/go/bin
export PATH=$HOME/.elixir-install/installs/otp/28.1/bin:$PATH
export PATH=$HOME/.elixir-install/installs/elixir/1.19.0-otp-28/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# Enable flux completion
command -v flux >/dev/null 2>&1 && source <(flux completion zsh)

# Enable kubectl completion
command -v kubectl >/dev/null 2>&1 && source <(kubectl completion zsh)

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# npm global (user-writable)
export PATH="$HOME/.npm-global/bin:$PATH"

# Added by flyctl installer
export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
