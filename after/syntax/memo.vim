nnoremap <leader><leader>r :set ft=memo<CR>

" TODO
" - siivoa
" - nimeä omat värit

syn keyword Todo TODO FIXME
syn keyword DiffAdd Esimerkki esimerkki Esim esim
syn match Todo "(blah blah)"

syn match Constant "^\s*>"
syn match Comment "#.*"
syn match Type "-\{80\}"
syn match Identifier "^- .*"
syn match Statement "^[a-zA-Z0-9].*"
syn match ModeMsg "\*[^(]*"

syn match CursorLine "_[a-zA-Z0-9]\+_"ms=s+1,me=e-1

syn match Constant "->.*"
syn match  NonText "\s*\$.*"
syn region NonText start="{\$" end="\$}" keepend

syn match level16c "^\s\+!.*"

syn match PreProc "[0-9]*[\.]\?[0-9]\+)"

syn match level16c "([^)]*?)"
syn match level16c "(!)"

syn match Identifier "^\s\+(.*)$"

syn match Type "\.\.\."
syn match Type "+"
