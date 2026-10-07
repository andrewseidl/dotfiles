# heroku
[ -f /usr/local/heroku ] && PATH="/usr/local/heroku/bin:$PATH"

# go
export GOPATH="$HOME"
PATH="$GOPATH/bin:$PATH"

# google cloud
if [ -d "$HOME/.gcloud/google-cloud-sdk" ]; then
    shell_name=${0#-}
    gcloud_path="$HOME/.gcloud/google-cloud-sdk/path.$shell_name.inc"
    gcloud_completion="$HOME/.gcloud/google-cloud-sdk/completion.$shell_name.inc"
    [ -r "$gcloud_path" ] && . "$gcloud_path"
    [ -r "$gcloud_completion" ] && . "$gcloud_completion"
fi
unset shell_name gcloud_path gcloud_completion

# added by travis gem
[ -r "$HOME/.travis/travis.sh" ] && . "$HOME/.travis/travis.sh"

# colorize ls
if [ "$(uname)" = 'Darwin' ]; then
    alias ls="ls -G"
    if command -v brew >/dev/null 2>&1; then
        export PATH="$(brew --prefix ruby)/bin:$PATH"
    fi
else
    alias ls="ls --color=auto"
fi

# open
if ! hash open 2>/dev/null; then
    alias open=xdg-open
fi

# ldd
if ! hash ldd 2>/dev/null; then
    if hash otool 2>/dev/null; then
	alias ldd="otool -L"
    fi
fi

# lynx
if [ -f ~/.lynx.lss ] ; then
    export LYNX_LSS=~/.lynx.lss
fi
if [ -f ~/.lynx.cfg ] ; then
    export LYNX_CFG=~/.lynx.cfg
fi

# hub
if hash hub 2>/dev/null; then
    alias git=hub
fi

# clang-format
if ! hash clang-format 2>/dev/null; then
    if hash clang-format-3.5 2>/dev/null; then
	alias clang-format=clang-format-3.5
    fi
fi

#### ruby and gems
###if hash ruby 2>/dev/null && hash gem 2>/dev/null; then
###    PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
###fi

# dircolors
if [ -f ~/.dir_colors ] ; then
    if hash dircolors 2>/dev/null; then
	eval $(dircolors ~/.dir_colors)
    elif hash gdircolors 2>/dev/null; then
	eval $(gdircolors ~/.dir_colors)
    fi
fi

# cabal
[ -d "$HOME/.cabal/bin" ] && PATH="$HOME/.cabal/bin:$PATH"

export LC_COLLATE="en_US.UTF-8"

PATH=$HOME/node_modules/.bin:$PATH

export PATH=$HOME/bin:/usr/local/bin:$PATH

# stolen from https://coderwall.com/p/powgbg
# FIXME: potential issue with FreeBSD
ssht() {
    ssh $* -t 'tmux a || tmux || /bin/zsh || /bin/bash'
}

alias shopt=/bin/false

# vim
alias vi="echo No."
## use neovim when available
#if hash nvim 2>/dev/null; then
#    alias vim=nvim
#fi
export EDITOR=vim

export CMAKE_GENERATOR=Ninja

export VCPKG_DISABLE_METRICS=1

# misc
# Keep sudo's secure_path intact; privileged commands must not inherit user-writable PATH entries.

# create a temporary dir and cd to it
alias cdtemp='cd $(mktemp -d /tmp/tmpd.$(date +%s).XXX)'
alias cdlasttemp='cd $(ls -d /tmp/tmpd* | tail -n1)'

[ -r "$HOME/.profile.local" ] && . "$HOME/.profile.local"
export ESPIDF=/opt/esp-idf
export PM_PACKAGES_ROOT=$HOME/packman-repo

if [ -r "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi
