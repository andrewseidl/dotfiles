" Insiration from:
" - Bendyworks: https://github.com/bendyworks/buffet

" source a file if it exists
function! SourceIfExists(filename)
  if filereadable(a:filename) | execute 'source ' . a:filename | endif
endfunction

" Import native .vimrc
call SourceIfExists($HOME . "/.vimrc")
