set nocompatible

syntax on
filetype plugin indent on


set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'

" original repos on github
Plugin 'airblade/vim-gitgutter'
Plugin 'elzr/vim-json'
Plugin 'fugalh/desert.vim'
Plugin 'godlygeek/tabular'
Plugin 'ivyl/vim-bling'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'majutsushi/tagbar'
Plugin 'pangloss/vim-javascript'
Plugin 'rking/ag.vim'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'Shougo/unite.vim'
Plugin 'terryma/vim-expand-region'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-surround'
Plugin 'Valloric/YouCompleteMe'
Plugin 'yuyuyu101/vim-cpplint'

call vundle#end()


set autoindent
set autoread
set background=dark
set backspace=2
set cmdheight=2
set diffopt+=iwhite
set history=1000
set hlsearch
set ignorecase
set incsearch
set lazyredraw
set number
set scrolloff=5
set showcmd
set showfulltag
set showmatch
set textwidth=80
set wildmenu

" these may get overridden by tpope/vim-sleuth
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

colorscheme desert

let g:ycm_confirm_extra_conf = 0


" disable arrow keys
" hard mode some day
noremap   <Up>      <Nop>
noremap   <Down>    <Nop>
noremap   <Right>   <Nop>
noremap   <Left>    <Nop>



" tmux compatibility
" stolen from http://www.codeography.com/2013/06/19/navigating-vim-and-tmux-splits.html
if exists('$TMUX')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let previous_winnr = winnr()
    execute "wincmd " . a:wincmd
    if previous_winnr == winnr()
      " The sleep and & gives time to get back to vim so tmux's focus tracking
      " can kick in and send us our ^[[O
      execute "silent !sh -c 'sleep 0.01; tmux select-pane -" . a:tmuxdir . "' &"
      redraw!
    endif
  endfunction
  let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
  let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
  let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te
  nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
  nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l
endif
