#!/bin/sh

if hash git 2>/dev/null ; then
    
    [[ ! -e $HOME/.homesick/repos/homeshick ]] && git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
    source $HOME/.homesick/repos/homeshick/homeshick.sh

    homeshick clone andrewseidl/dotfiles

    # install Vundle for vim
    [[ ! -e $HOME/.vim/bundle/Vundle.vim ]] && git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

    # tell Vundle to install plugins
    vim +PluginInstall +qall

    # install syntax highlighting for zsh
    [[ ! -e $HOME/.zsh/plugins/zsh-syntax-highlighting ]] && git clone git://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/plugins/zsh-syntax-highlighting
else
    echo "Please install Git and then rerun."
fi
