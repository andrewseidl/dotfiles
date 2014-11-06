PATH="/usr/local/heroku/bin:$PATH"

# google cloud
if [ -f ~/google-cloud-sdk/path.zsh.inc ] ; then
    source "$HOME/google-cloud-sdk/path.zsh.inc"

    source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# homeshick
if [ -e ~/.homesick ] ; then
    source "$HOME/.homesick/repos/homeshick/homeshick.sh"
    fpath=(~/.homesick/repos/homeshick/completions $fpath)
fi

# colorize ls 
if [ "`uname`" = 'Darwin' ] ; then
    alias ls="ls -G"
    export PATH=$(brew --prefix ruby)/bin:$PATH
else
    alias ls="ls --color"
fi

# open
if hash open 2>/dev/null; then
    alias open=xdg-open
fi

# ruby and gems
if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

# dircolors
if [ -f ~/.dir_colors ] ; then
    if hash dircolors 2>/dev/null; then
	eval `dircolors ~/.dir_colors`
    elif hash gdircolors 2>/dev/null; then
	eval `gdircolors ~/.dir_colors`
    fi  
fi

export LC_COLLATE="en_US.UTF-8"

export PATH=/usr/local/bin:$PATH

# stolen from https://coderwall.com/p/powgbg
function ssht() {
    ssh $* -t 'tmux a || tmux || /bin/zsh || /bin/bash'
}

alias shopt=/bin/false
alias vi="echo No."

