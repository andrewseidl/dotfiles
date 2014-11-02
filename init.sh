#!/bin/sh

if hash git 2>/dev/null ; then
    
    [[ ! -e $HOME/.homesick/repos/homeshick ]] && git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
    source $HOME/.homesick/repos/homeshick/homeshick.sh

    homeshick clone andrewseidl/dotfiles

    [[ ! -e $HOME/.vim/bundle/Vundle.vim ]] && git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

else
    echo "Please install Git and then rerun."
fi
