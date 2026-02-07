# Path to your oh-my-zsh installation.
ZSH=$HOME/.oh-my-zsh

# List of plugins used
plugins=(
    zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

unsetopt beep # Get rid of the fucking shell water droplet sound
CASE_SENSITIVE="false"

# eza aliases (omarchy-style)
alias ls='eza --icons'
alias l='eza --icons -l'
alias ll='eza --icons -la'
alias lt='eza --icons --tree --level=2'
alias lsa='eza --icons -a'
alias lta='eza --icons --tree --level=2 -a'
alias nv="nvim"

# fzf with preview (omarchy-style)
alias ff='fzf --preview "cat {}"'

# try - experiment directories (omarchy-style)
try() {
  local dir="$HOME/Work/tries/$(date +%Y-%m-%d)-$1"
  mkdir -p "$dir"
  cd "$dir"
}

alias cd='z'
alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias config='/usr/bin/git --git-dir=$HOME/dotfiles-macos/ --work-tree=$HOME'
alias search='fzf --preview="bat --color=always {}"'
alias mkdir='mkdir -p'
alias x='exit'

alias sync-brain="cd ~/Sync/SecondBrain ; git pull ; git add . ; git commit -am \"Automated update.\" ; git push ; cd -"

alias xc="xclip"
alias xv="xclip -o"
alias cs="xclip -selection clipboard"
alias vs="xclip -o -selection clipboard"

# Environment variables
export PATH="$PATH:$HOME/.local/bin"

# Rust/Cargo
. "$HOME/.cargo/env"

export GPG_TTY=$(tty)

# If you need Android development tools, update these paths:
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

eval "$(starship init zsh)"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
eval "$(zoxide init zsh)"
eval "$(alias sketchybar="$HOME/.config/sketchybar/set-bar-mode.sh")"
