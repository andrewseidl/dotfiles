" Inspiration from:
" - Aaron Bartholomew: github.com/abartholome2/vim-xtreme
" - Jon Childress: github.com/jonplussed/dotfiles
" - ryanss: github.com/ryanss/vim
" - Jessie Frazelle: github.com/jfrazelle/.vim

set nocompatible
set encoding=utf-8

syntax on
filetype off


"" plugins

" Auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  call system("curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
endif

call plug#begin('~/.vim/plugged')

" let Vundle manage Vundle
Plug 'gmarik/Vundle.vim'

" original repos on github
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ervandew/supertab'
"Plug 'godlygeek/tabular'
Plug 'johnsyweb/vim-makeshift'
Plug 'jtratner/vim-flavored-markdown'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'kien/ctrlp.vim', { 'on': 'CtrlP' }
Plug 'kopischke/vim-fetch'
Plug 'kurkale6ka/vim-pairs'
"Plug 'Lokaltog/vim-easymotion'
Plug 'luochen1990/rainbow'
Plug 'lyuts/vim-rtags'
Plug 'majutsushi/tagbar'
Plug 'mfukar/robotframework-vim'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdcommenter', { 'on': 'NERDComToggleComment' }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'scrooloose/syntastic'
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
"Plug 'vim-scripts/Conque-GDB'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
if !has('nvim')
  Plug 'Valloric/YouCompleteMe'
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'Shougo/neoinclude.vim'
  Plug 'zchee/deoplete-go'
  Plug 'zchee/deoplete-clang'
endif

" code formatting
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'

" language-specific
Plug 'rhysd/vim-clang-format' " C++
Plug 'fatih/vim-go'           " Go
Plug 'eagletmt/ghcmod-vim'    " Haskell
Plug 'eagletmt/neco-ghc'      " Haskell
Plug 'Shougo/vimproc'         " Haskell, for ghcmod
Plug 'JuliaLang/julia-vim'    " Julia
Plug 'davidhalter/jedi-vim'   " Python

call plug#end()

if has('nvim')
  let g:deoplete#enable_at_startup = 1
  inoremap <silent><expr> <Tab>
              \ pumvisible() ? "\<C-n>" : "<Tab>"
  let g:deoplete#sources#clang#libclang_path = "/usr/local/Cellar/llvm/3.9.1/lib/libclang.dylib"
  let g:deoplete#sources#clang#clang_header = "/usr/local/Cellar/llvm/3.9.1/lib/clang/3.9.1/"
endif

" Auto-install remaining plugins. FIXME: bad plugin check
if !isdirectory(expand("~/.vim/plugged/vim-fugitive"))
  execute 'silent PlugInstall'
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
set nolazyredraw
set ttyfast
set number
set scrolloff=5
set showcmd
set showfulltag
set showmatch
" set textwidth=80
set virtualedit=all
set wildmenu

"colors
set fillchars=vert:│,fold:-
highlight VertSplit cterm=none ctermbg=none ctermfg=247

" undo
if !isdirectory(expand("~/.vim/undo"))
  call system("mkdir -p ~/.vim/undo")
endif
set undofile
set undodir=~/.vim/undo
set undolevels=1000
set undoreload=10000

" Jump to the last position when reopening a file
if !has('nvim')
  set viminfo='100,\"300,:200,%,n~/.viminfo
else
  set viminfo='100,\"300,:200,%,n~/.nviminfo
endif
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" because we have standards -jonplussed
"set textwidth=79

" these may get overridden by tpope/vim-sleuth
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

"" key bindings
let mapleader = " "
nmap <space> <leader>

" clear highlights
nmap <silent> <leader>/ :nohlsearch<CR>

" toggle wrapping
nmap <leader>w :set wrap!<CR>

" save with sudo if regular user
cmap w!! w !sudo tee > /dev/null %

" up/down by visual line, not actual line
nnoremap j gj
nnoremap k gk

" disable arrow keys
" hard mode some day
noremap   <Up>      <Nop>
noremap   <Down>    <Nop>
noremap   <Right>   <Nop>
noremap   <Left>    <Nop>

" center the screen on search results
nnoremap n  nzz
nnoremap N  Nzz
nnoremap *  *zz
nnoremap #  #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.
"
" Note: Must allow nesting of autocmds to enable any customizations for quickfix
" buffers.
" Note: Normally, :cwindow jumps to the quickfix window if the command opens it
" (but not if it's already open). However, as part of the autocmd, this doesn't
" seem to happen.
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" quickfix
map <C-n> :cn<CR>
map <C-m> :cp<CR>
nnoremap <leader>a :cclose<CR>

"" plugin options

"airline
let g:airline#extensions#tabline#enabled = 0
let g:airline_powerline_fonts = 0
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_y=""
let g:airline_theme='murmur'

"clang-format
" map to <leader>cf in C++ code
"autocmd FileType c,cpp,objc nnoremap <buffer><leader>cf :<C-u>ClangFormat<CR>
"autocmd FileType c,cpp,objc vnoremap <buffer><leader>cf :ClangFormat<CR>
" if you install vim-operator-user
"autocmd FileType c,cpp,objc map <buffer><leader>x <Plug>(operator-clang-format)
" Toggle auto formatting:
"nmap <leader>C :ClangFormatAutoToggle<CR>

"ctrlp
map <c-p> :FZF ..<CR>

"google-codefmt
call glaive#Install()
Glaive codefmt plugin[mappings]
autocmd FileType c,cpp,objc,java,javascript,python,html,css,json nnoremap <buffer><leader>cf :<C-u>FormatCode<CR>
autocmd FileType c,cpp,objc,java,javascript,python,html,css,json vnoremap <buffer><leader>cf :FormatCode<CR>
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
"highlight clear SignColumn

"Jedi
autocmd FileType python setlocal completeopt-=preview

"makeshift
let g:makeshift_use_pwd_first = 1
let g:makeshift_chdir = 1

"NERDCommenter
let NERDSpaceDelims=1
map <leader>cc :NERDComToggleComment<CR>

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

"rainbow-parens
let g:rainbow_active = 1

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

"vim-flavored-markdown
augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

"vim-go
let g:go_fmt_command = "goimports"

"YouCompleteMe
let g:ycm_confirm_extra_conf = 0
nnoremap <leader>jd :YcmCompleter GoTo<CR>

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
