#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

# /grml: http://grml.org/zsh/zsh-lovers.html

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

HISTSIZE=20000
HISTFILE=~/.history
SAVEHIST=20000

## never ever beep ever
#setopt NO_BEEP

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


prompt_gentoo_prompt=${1:-'cyan'}
prompt_gentoo_user=${2:-'green'}
prompt_gentoo_root=${3:-'red'}

if [ "$USER" = 'root' ]
then
  base_prompt="%B%F{$prompt_gentoo_root}%m%k "
  end_prompt="#"
else
  base_prompt="%B%F{$prompt_gentoo_user}%n@%m%k "
  end_prompt="$"
fi
post_prompt="%b%f%k"

#setopt noxtrace localoptions

path_prompt="%B%F{$prompt_gentoo_prompt}%1~"
PS1="$base_prompt$path_prompt $end_prompt $post_prompt"
PS2="$base_prompt$path_prompt %_> $post_prompt"
PS3="$base_prompt$path_prompt ?# $post_prompt"


if [ -f ~/.profile ]
then
  source ~/.profile
fi


if [ -f ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]
then
    source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
