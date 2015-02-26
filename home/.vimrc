" Insiration from:
" - Aaron Bartholomew: https://github.com/abartholome2/vim-xtreme
" - Jon Childress: github.com/jonplussed/dotfiles
" - ryanss: gihub.com/ryanss/vim

set nocompatible
set encoding=utf-8

syntax on
filetype off


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
Plugin 'christoomey/vim-tmux-navigator'
"Plugin 'ervandew/supertab'
Plugin 'fugalh/desert.vim'
Plugin 'godlygeek/tabular'
Plugin 'kien/ctrlp.vim'
Plugin 'kopischke/vim-fetch'
Plugin 'kurkale6ka/vim-pairs'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'majutsushi/tagbar'
Plugin 'rking/ag.vim'
Plugin 'Rykka/riv.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'sotte/presenting.vim'
Plugin 'terryma/vim-expand-region'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-surround'
"Plugin 'Valloric/YouCompleteMe'
"Plugin 'SirVer/ultisnips'
"Plugin 'honza/vim-snippets'

" code formatting
Plugin 'google/vim-maktaba'
Plugin 'google/vim-codefmtlib'
Plugin 'google/vim-codefmt'
Plugin 'google/vim-glaive'

" language-specific
Plugin 'rhysd/vim-clang-format' " C++
Plugin 'fatih/vim-go'           " Go
Plugin 'eagletmt/ghcmod-vim'    " Haskell
Plugin 'eagletmt/neco-ghc'      " Haskell
Plugin 'Shougo/vimproc'         " Haskell, for ghcmod
Plugin 'JuliaLang/julia-vim'    " Julia
Plugin 'davidhalter/jedi-vim'   " Python

call vundle#end()

" Auto-install remaining plugins. FIXME: bad plugin check
if !isdirectory(expand("~/.vim/bundle/vim-fugitive"))
  execute 'silent PluginInstall'
  execute 'silent q'
endif

filetype plugin indent on


"" options

set autoindent
set autoread
set background=dark
set backspace=2
set diffopt+=iwhite
set history=50
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
let g:airline_powerline_fonts = 0
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_y=""
let g:airline_theme='raven'

"clang-format
" map to <leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><leader>cf :ClangFormat<CR>
" if you install vim-operator-user
autocmd FileType c,cpp,objc map <buffer><leader>x <Plug>(operator-clang-format)
" Toggle auto formatting:
nmap <leader>C :ClangFormatAutoToggle<CR>

"google-codefmt
" map to <leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><leader>fc :<C-u>FormatCode<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><leader>fc :FormatCode<CR>
" Enable auto formatting:
nmap <leader>gcf :AutoFormatBuffer<CR>

"GHCMod
nnoremap <buffer> <Leader>ht :GhcModType<CR>
nnoremap <buffer> <Leader>hh :GhcModTypeClear<CR>
nnoremap <buffer> <Leader>hc :GhcModCheck<CR>
nnoremap <buffer> <Leader>hl :GhcModLint<CR>
au FileType haskell setlocal omnifunc=necoghc#omnifunc
let g:necoghc_enable_detailed_browse = 1
au FileType haskell nnoremap <buffer> <Leader>h :! cabal test --show-details=always --test-options="--color"<CR>

"gitgutter
highlight clear SignColumn

"Jedi
autocmd FileType python setlocal completeopt-=preview

"NERDCommenter
let NERDSpaceDelims=1

"NERDTree
map <leader>d :NERDTreeToggle<CR>
map <leader>e :NERDTreeFind<CR>
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=0
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=0
let NERDTreeSortOrder=['*', '\.swp$',  '\.bak$', '\~$']
"close vim if only NERDTree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"Tagbar
map <leader>t :TagbarToggle<CR>

"Tabularize
nmap <leader>a= :Tabularize /=<CR>
vmap <leader>a= :Tabularize /=<CR>
nmap <leader>a: :Tabularize /:\zs<CR>
vmap <leader>a: :Tabularize /:\zs<CR>

"UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

"vim-go
let g:go_fmt_command = "goimports"

"YouCompleteMe
let g:ycm_confirm_extra_conf = 0
nnoremap <leader>jd :YcmCompleter GoTo<CR>
