# Path to your oh-my-zsh installation.
ZSH=$HOME/.oh-my-zsh

# Path to powerlevel10k theme
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme

# List of plugins used
plugins=(
    zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

function pipx_inject_requirements () {
    pipx runpip $1 install -r $2
}

unsetopt beep # Get rid of the fucking shell water droplet sound
CASE_SENSITIVE="false"


function gt() {
    # gt - Go To directory with Selection
    # Shows multiple results and lets you choose
    
    if [ $# -eq 0 ]; then
        echo "Usage: gts <directory_name>"
        return 1
    fi

    local search_term="$1"
    local results=$(fd --type d --ignore-case "$search_term" 2>/dev/null)
    
    if [ -z "$results" ]; then
        echo "No directories found matching: $search_term"
        return 1
    fi
    
    # Count results
    local count=$(echo "$results" | wc -l)
    
    if [ "$count" -eq 1 ]; then
        echo "Found 1 match:"
        echo "$results"
        echo "Navigating to: $results"
        cd "$results"
        pwd
    else
        echo "Found $count matches:"
        echo "$results" | nl
        echo
        echo "Navigating to first result: $(echo "$results" | head -1)"
        cd "$(echo "$results" | head -1)"
        pwd
    fi
}

# Helpful aliases
alias  l='ls -lh' # long list
alias ls='ls -1' # short list
alias ll='ls -lha' # long list all
alias ld='ls -lhd */' # long list dirs
alias nv="nvim"

alias gs='git status -sb'
alias gco='git checkout'
alias gcm='git checkout master'
alias gaa='git add --all'
alias gc='git commit -m $2'
alias commit='git commit'
alias gca='git commit -a'
alias push='git push'
alias gpo='git push origin'
alias pull='git pull'
alias clone='git clone'
alias stash='git stash'
alias pop='git stash pop'
alias ga='git add'
alias gb='git branch'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gm='git merge'

alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias x="exit"

alias config='/usr/bin/git --git-dir=$HOME/dotfiles-macos/ --work-tree=$HOME'
alias search='fzf --preview="bat --color=always {}"'
alias mkdir='mkdir -p'

alias sync-brain="cd ~/Sync/SecondBrain ; git pull ; git add . ; git commit -am \"Automated update.\" ; git push ; cd -"
alias nsusb="java -jar ~/Sync/personalCode/ns-usbloader-7.2-m1.jar"
alias glow="glow --config ~/.config/glow/glow.yml -s ~/.config/glow/gruvbox-retro.json"

alias c="xclip"
alias v="xclip -o"
alias cs="xclip -selection clipboard"
alias vs="xclip -o -selection clipboard"

# Environment variables
export PATH="$PATH:$HOME/.local/bin"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export GPG_TTY=$(tty)

# If you need Android development tools, update these paths:
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

eval "$(starship init zsh)"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

eval "$(alias sketchybar="$HOME/.config/sketchybar/set-bar-mode.sh")"
