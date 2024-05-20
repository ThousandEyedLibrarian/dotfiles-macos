## Setup
```
git init --bare $HOME/dotfiles
alias alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
config add <file>
config commit -m "Example"
config push
```

### Update
```
config pull
```

### New System
```
git clone --bare git@github.com:CarterFaceySmith/dotfiles.git $HOME/dotfiles
alias alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
config checkout
```

### References
[Atlassian Bare Repo Dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)
