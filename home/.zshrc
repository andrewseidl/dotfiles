#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

# /grml: http://grml.org/zsh/zsh-lovers.html

zmodload zsh/zprof

autoload -U compinit
compinit

# url quote magic: automagically escape out urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## history
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS

# run 'rehash' automatically
setopt nohashdirs

HISTSIZE=20000
HISTFILE=~/.history
SAVEHIST=20000

## never ever beep ever
setopt NO_BEEP

## automatically decide when to page a list of completions
LISTMAX=0

## disable mail checking
#MAILCHECK=0

autoload -U colors
colors

# edit command lines
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

## enable autocorrect
zstyle ':completion:::::' completer _complete _approximate
#zstyle ':completion:*:approximate:*' max-errors 2
zstyle ':completion:*' menu select

# increase number of allowed errors as more is entered /grml
zstyle -e ':completion:*:approximate:*' \
  max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# ignore completeion for unknown commands /grml
zstyle ':completion:*:functions' ignored-patterns '_*'

# complete process ids with menu /grml
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

# complete .ssh/config hostnames
zstyle -e ':completion:*:*:ssh:*:my-accounts' users-hosts \
  '[[ -f ~/.ssh/config && $key = hosts ]] && key=my_hosts reply=()'

# quick changed directories /grml
rationalise-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

# fix key bindings
bindkey "\e[1~" beginning-of-line # Home
bindkey "\e[4~" end-of-line # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "\e[2~" quoted-insert # Ins
bindkey "\e[3~" delete-char # Del
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[Z" reverse-menu-complete # Shift+Tab
# for rxvt
bindkey "\e[7~" beginning-of-line # Home
bindkey "\e[8~" end-of-line # End
# for non RH/Debian xterm, can't hurt for RH/Debian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# for guake
bindkey "\eOF" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "\e[3~" delete-char # Del


# auto pushd directories
# from https://wiki.archlinux.org/index.php/Zsh#Dirstack
DIRSTACKFILE="$HOME/.cache/zsh/dirs.$$"
mkdir -p $(dirname $DIRSTACKFILE)
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

DIRSTACKSIZE=20

setopt autopushd pushdsilent pushdtohome

## Remove duplicate entries
setopt pushdignoredups

## This reverts the +/- operators.
setopt pushdminus


if [ -f ~/.profile ]
then
  source ~/.profile
fi


ZGIT=~/.zsh/plugins/zsh-git-prompt

EXTRA_STATUS=""
if [ -f $ZGIT/zshrc.sh ] ; then
  export ZSH_THEME_GIT_PROMPT_CACHE
  source $ZGIT/zshrc.sh
  EXTRA_STATUS='$(git_super_status)'
  #export RPROMPT='%B%m %~%b'
fi

if [ -f $ZGIT/src/.bin/gitstatus ] ; then
  export GIT_PROMPT_EXECUTABLE="haskell"
fi

prompt_prompt=${1:-'cyan'}
prompt_user=${2:-'green'}
prompt_root=${3:-'red'}

MACHINE=""
if [ "$SSH_CLIENT" ] ; then
  MACHINE='%m%k '
fi
if [ "$USER" = 'root' ]
then
  base_prompt="%B%F{$prompt_root}$MACHINE"
  end_prompt="#"
else
  base_prompt="%B%F{$prompt_user}$MACHINE"
  end_prompt="$"
fi
post_prompt="%b%f%k"

#setopt noxtrace localoptions

path_prompt="%B%F{$prompt_prompt}%1~"
ZSH_THEME_GIT_PROMPT_SUFFIX="%B%F{$prompt_prompt}) "
PS1="$base_prompt$path_prompt $EXTRA_STATUS$end_prompt $post_prompt"
PS2="$base_prompt$path_prompt %_> $post_prompt"
PS3="$base_prompt$path_prompt ?# $post_prompt"

if [ -f ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]
then
    source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Stolen from https://gist.github.com/fl0w/07ce79bd44788f647deab307c94d6922#gistcomment-2650045
# Add every binary that requires nvm, npm or node to run to an array of node globals
export NVM_DIR=~/.nvm
[ -d "${NVM_DIR}/versions/node" ] && NODE_GLOBALS=(`find ${NVM_DIR}/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
NODE_GLOBALS+=("node")
NODE_GLOBALS+=("nvm")

# Lazy-loading nvm + npm on node globals call
load_nvm () {
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
}

# Making node global trigger the lazy loading
for cmd in "${NODE_GLOBALS[@]}"; do
  eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
done
