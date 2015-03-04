# heroku
[ -f /usr/local/heroku ] && PATH="/usr/local/heroku/bin:$PATH"

# go
export GOPATH="$HOME/.go"
PATH="$GOPATH/bin:$PATH"

# google cloud
if [ -f ~/.gcloud/google-cloud-sdk ] ; then
    export CLOUDSDK_PYTHON=python2
    shell=$(echo "$0" | grep -o "[a-z]*") # hack, zsh sometimes gives -zsh

    source "$HOME/.gcloud/google-cloud-sdk/path.$shell.inc"
    source "$HOME/.gcloud/google-cloud-sdk/completion.$shell.inc"
fi

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# colorize ls 
if [ "$(uname)" = 'Darwin' ] ; then
    alias ls="ls -G"
    export PATH=$(brew --prefix ruby)/bin:$PATH
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

# hub
if hash hub 2>/dev/null; then
    alias git=hub
fi

# ruby and gems
if hash ruby 2>/dev/null && hash gem 2>/dev/null; then
    PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

# dircolors
if [ -f ~/.dir_colors ] ; then
    if hash dircolors 2>/dev/null; then
	eval $(dircolors ~/.dir_colors)
    elif hash gdircolors 2>/dev/null; then
	eval $(gdircolors ~/.dir_colors)
    fi  
fi

# cabal
[[ -f $HOME/.cabal/bin ]] && PATH=$HOME/.cabal/bin:$PATH

export LC_COLLATE="en_US.UTF-8"

export PATH=$HOME/bin:/usr/local/bin:$PATH

# stolen from https://coderwall.com/p/powgbg
# FIXME: potential issue with FreeBSD
function ssht() {
    ssh $* -t 'tmux a || tmux || /bin/zsh || /bin/bash'
}

alias shopt=/bin/false
alias vi="echo No."

