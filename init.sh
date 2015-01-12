#!/bin/sh

DFDIR="$HOME/.dotfiles"

# check if git is installed
if !hash git 2>/dev/null ; then
    echo "Please install Git and then rerun."
fi

# install syntax highlighting for zsh
ZSHL=$HOME/.zsh/plugins/zsh-syntax-highlighting
if [[ ! -e $ZSHL ]] ; then
    git clone git://github.com/zsh-users/zsh-syntax-highlighting.git $ZSHL
fi

# clone dotfiles if they don't exist
if [[ ! -e "$DFDIR" ]] ; then
    git clone git://github.com/andrewseidl/dotfiles.git "$DFDIR"
fi

# enter dotfiles dir
pushd $PWD >/dev/null
cd "$DFDIR"

# pull updates if there are no outstanding changes
if git diff --quiet ; then
    git pull --quiet
else
    git status -s
fi

# for each dotfile, back up existing in $HOME and symlink new 
for i in $( find $PWD/home -maxdepth 1 -mindepth 1 ); do
    HOMEFILE="$HOME/$( basename $i )"
    if [[ -e $HOMEFILE ]] ; then
        if [[ "$i" != "$( readlink $HOMEFILE)" ]] ; then
            mv $HOMEFILE{,.bak-$(date +%Y%m%d)}
        fi
    fi
    ln -sf $i $HOME/
done

popd >/dev/null
