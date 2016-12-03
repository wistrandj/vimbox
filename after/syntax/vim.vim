" syntax region vimFoldFunc
" \    start="function"
" \    end="endfunction"
" \    keepend
" \    transparent
" \    fold

" set foldmethod=syntax

syn clear
hi vimLineComment ctermfg=green
syn match vimLineComment "\"[^\"]*$"
syn match vimString "\"[^\"]*\""

hi vimFuncKey ctermfg=yellow
syn keyword vimFuncKey fu fun func funct functi functio function endfu endfun endfunc endfunct endfuncti endfunctio endfunction wh whi whil while endwh endwhi endwhil if el els else elsei elseif en end endi endif for endfor
syn keyword vimFuncKey com comm comma comman command
syn match vimFuncKey "\w*map"
syn keyword vimFuncKey nn nnr nnre nnrem nnrema nnremap

" syn keyword vimFuncKey map
" syn match vimFuncKey "map\!"
" map
" map!
" smap
" nm[ap]
" vm[ap]
" xm[ap]
" om[ap]
" im[ap]
" lm[ap]
" cm[ap]






hi Folded ctermfg=blue ctermbg=none
hi vimFuncKey ctermfg=yellow
hi vimMap ctermfg=yellow
hi Statement ctermfg=none
