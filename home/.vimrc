" Inspiration from:
" - Aaron Bartholomew: github.com/abartholome2/vim-xtreme
" - Jon Childress: github.com/jonplussed/dotfiles
" - ryanss: github.com/ryanss/vim
" - Jessie Frazelle: github.com/jfrazelle/.vim

set nocompatible
set encoding=utf-8

syntax on
filetype off

if !has('nvim')
  let vimconfig = '~/.vim'
else
  let vimconfig = '~/.local/share/nvim'
endif

"" plugins

" Auto-install vim-plug
if empty(glob(vimconfig . '/autoload/plug.vim'))
  call system("curl -fLo " . vimconfig . "/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
endif

call plug#begin(vimconfig . "/plugged")

" let Vundle manage Vundle
Plug 'gmarik/Vundle.vim'

" original repos on github
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
"Plug 'ervandew/supertab'
"Plug 'godlygeek/tabular'
Plug 'johnsyweb/vim-makeshift'
Plug 'jtratner/vim-flavored-markdown'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'kien/ctrlp.vim', { 'on': 'CtrlP' }
Plug 'kopischke/vim-fetch'
Plug 'kurkale6ka/vim-pairs'
Plug 'easymotion/vim-easymotion'
Plug 'luochen1990/rainbow'
"Plug 'lyuts/vim-rtags'
Plug 'majutsushi/tagbar'
Plug 'ntpeters/vim-better-whitespace'
Plug 'cohama/lexima.vim'
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
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
if has('nvim')
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

" code formatting
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'

" language-specific
Plug 'rhysd/vim-clang-format' " C++
"Plug 'libclang-vim/clang-type-inspector.vim' | Plug 'rhysd/libclang-vim', { 'for': ['cpp'] }
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
endif

" Auto-install remaining plugins. FIXME: bad plugin check
if !isdirectory(expand(vimconfig . '/plugged/vim-fugitive'))
  execute 'silent PlugInstall'
  execute 'silent q'
endif

filetype plugin indent on



""" coc

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>



""" coc



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
autocmd FileType c,cpp,objc,java,javascript,python,html,css,json,rust nnoremap <buffer><leader>cf :<C-u>FormatCode<CR>
autocmd FileType c,cpp,objc,java,javascript,python,html,css,json,rust vnoremap <buffer><leader>cf :FormatCode<CR>
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

"vim-better-whitespace
let g:better_whitespace_filetypes_blacklist=['diff']

"vim-flavored-markdown
augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

"vim-go
let g:go_fmt_command = "goimports"

let g:clang_rename_path = "clang-rename"
noremap <leader>cr :pyf /usr/share/clang/clang-rename.py<CR>
