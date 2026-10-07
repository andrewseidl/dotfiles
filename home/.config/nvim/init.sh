#!/usr/bin/env bash

DFDIR="$HOME/.dotfiles"

# check if git is installed
if ! command -v git &>/dev/null ; then
    echo "Please install Git and then rerun." >&2
    exit 1
fi

# install syntax highlighting for zsh
ZSHL=$HOME/.zsh/plugins/zsh-syntax-highlighting
if [[ ! -e $ZSHL ]] ; then
    mkdir -p "$(dirname "$ZSHL")"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSHL"
fi

# install git prompt for zsh
ZSHP=$HOME/.zsh/plugins/zsh-git-prompt
if [[ ! -e $ZSHP ]] ; then
    mkdir -p "$(dirname "$ZSHP")"
    git clone https://github.com/olivierverdier/zsh-git-prompt.git "$ZSHP"
fi

# install fzf
FZFDIR=$HOME/.fzf
if [[ ! -e $FZFDIR ]] ; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$FZFDIR"
    "$FZFDIR/install" --all
fi

# clone dotfiles if they don't exist
if [[ ! -e "$DFDIR" ]] ; then
    git clone https://github.com/andrewseidl/dotfiles.git "$DFDIR"
fi

# enter dotfiles dir
pushd "$DFDIR" >/dev/null

# pull updates if there are no outstanding changes
if git diff --quiet ; then
    git pull --quiet
else
    git status -s
fi

# for each dotfile, back up existing in $HOME and symlink new
for i in $( find "$PWD/home" -maxdepth 1 -mindepth 1 ); do
    HOMEFILE="$HOME/$( basename "$i" )"
    if [[ -e "$HOMEFILE" || -L "$HOMEFILE" ]] ; then
        if [[ "$i" != "$( readlink "$HOMEFILE")" ]] ; then
            mv "$HOMEFILE" "${HOMEFILE}.bak-$(date +%Y%m%d)"
        fi
    fi
    ln -sf "$i" "$HOME/"
done

popd >/dev/null
