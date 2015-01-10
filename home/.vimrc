" Insiration from:
" - Aaron Bartholomew: https://github.com/abartholome2/vim-xtreme
" - Jon Childress: github.com/jonplussed/dotfiles
" - ryanss: gihub.com/ryanss/vim

set nocompatible
set encoding=utf-8

syntax on
filetype plugin indent on


"" plugins

" Auto-install Vundle
if !isdirectory(expand("~/.vim/bundle/Vundle.vim"))
  call system("git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim")
endif

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'

" original repos on github
Plugin 'airblade/vim-gitgutter'
Plugin 'bling/vim-airline'
Plugin 'fugalh/desert.vim'
Plugin 'godlygeek/tabular'
Plugin 'kien/ctrlp.vim'
Plugin 'kurkale6ka/vim-pairs'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'majutsushi/tagbar'
Plugin 'rhysd/vim-clang-format'
Plugin 'rking/ag.vim'
Plugin 'Rykka/riv.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'terryma/vim-expand-region'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-surround'
Plugin 'Valloric/YouCompleteMe'

call vundle#end()

" Auto-install remaining plugins. FIXME: bad plugin check
if !isdirectory(expand("~/.vim/bundle/vim-fugitive"))
  execute 'silent PluginInstall'
  execute 'silent q'
endif

"" options

set autoindent
set autoread
set background=dark
set backspace=2
set diffopt+=iwhite
set history=1000
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set number
set scrolloff=5
set showcmd
set showfulltag
set showmatch
" set textwidth=80
set wildmenu

" these may get overridden by tpope/vim-sleuth
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

colorscheme desert

let g:ycm_confirm_extra_conf = 0


"" key bindings
let mapleader = " "
nmap <space> <leader>

" clear highlights
nmap <silent> <leader>/ :nohlsearch<CR>

" up/down by visual line, not actual line
nnoremap j gj
nnoremap k gk

" disable arrow keys
" hard mode some day
noremap   <Up>      <Nop>
noremap   <Down>    <Nop>
noremap   <Right>   <Nop>
noremap   <Left>    <Nop>


"" plugin options

"airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

"nerdcommenter
let NERDSpaceDelims=1

"NERDTree
map <leader>d :NERDTreeToggle<CR>
map <leader>e :NERDTreeFind<CR>
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=0
let NERDTreeKeepTreeInNewTab=1

"Tagbar
map <leader>t :TagbarToggle<CR>

"Tabularize
nmap <leader>a= :Tabularize /=<CR>
vmap <leader>a= :Tabularize /=<CR>
nmap <leader>a: :Tabularize /:\zs<CR>
vmap <leader>a: :Tabularize /:\zs<CR>

"clang-format
" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" if you install vim-operator-user
autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)
" Toggle auto formatting:
nmap <Leader>C :ClangFormatAutoToggle<CR>


"" tmux compatibility

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
