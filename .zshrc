# The lines added by compinstall
zstyle :compinstall filename "${HOME}/.zshrc"

autoload -Uz compinit
compinit

# Lines for antigen setup
if uname -s | grep -qi darwin; then
    source $(brew --prefix)/share/antigen/antigen.zsh
else
    # the following is for Arch Linux AUR package antigen-git only
    source /usr/share/zsh/share/antigen.zsh
fi

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme robbyrussell

# Tell Antigen that you're done.
antigen apply

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
unsetopt nomatch

# Start SSH agent
if uname -s | grep -qi linux; then
    # Set XDG_RUNTIME_DIR, this is usually set by pam_systemd
    if [ -z $XDG_RUNTIME_DIR ]; then
        export XDG_RUNTIME_DIR=/tmp
    fi
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
    fi
    if [ -z "$SSH_AUTH_SOCK" ]; then
        source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
    fi
fi

alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
