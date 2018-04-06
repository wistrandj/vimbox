" syntax region vimFoldFunc
" \    start="function"
" \    end="endfunction"
" \    keepend
" \    transparent
" \    fold

" set foldmethod=syntax

finish
syn clear

hi vimFuncKey ctermfg=yellow
syn keyword vimFuncKey fu fun func funct functi functio function endfu endfun endfunc endfunct endfuncti endfunctio endfunction wh whi whil while endwh endwhi endwhil endwhile if el els else elsei elseif en endi endif for endfor return break continue in try endtry finally
syn keyword vimFuncKey com comm comma comman command
" syn match vimFuncKey "\w*map"
syn keyword vimFuncKey nn nnr nnre nnrem nnrema nnremap
syn keyword vimFuncKey syn synt syntax hi

hi vimMappingLine ctermfg=0
hi link vimMappingLineKeyword vimFuncKey
hi vimMappingLineMapping ctermfg=white
hi vimMappingLineRest ctermfg=gray
syn match vimMappingLine "^\(\w*map\w*\|cm\|lm\|im\|om\|sm\|xm\|vm\|nm\|cm\|lm\|im\|om\|sm\|xm\|vm\|nm\|cm\|lm\|im\|om\|xm\|vm\|nm\|no\|nn\|vn\|xn\|no\|ln\|vu\|xu\|ou\|iu\|lu\|cu\|nun\|cno\|ino\|ono\|snor\).*$" transparent contains=vimMappingLineKeyword
syn match vimMappingLineRest ".*" contained containedin=vimMappingLineRest
syn match vimMappingLineMapping "\S\+" contained containedin=vimMappingLine nextgroup=vimMappingLineRest
syn match vimMappingLineKeyword "^\w\+" contained containedin=vimMappingLine nextgroup=vimMappingLineMapping

hi vimOperator ctermfg=red
hi vimParen ctermfg=blue
syn match vimOperator "=\|+\|-"
syn match vimParen "\[\|\]\|{\|}\|(\|)"
syn match vimOperator ","
" syn match vimOperator "\V==\|==#\|==?\|!=\|!=#\|!=?\|>#\|>?\|>=\|>=#\|>=?\|<#\|<?\|<=\|<=#\|<=?\|<\|>\|=~\|=~#\|=~?\|!~\|!~#\|!~?\|isnot#\|isnot?\|isnot\|is#\|is?\|is"

hi vimEscapedChar ctermfg=darkred
" syn match vimEscapedChar "\\(.*\\)" containedin=vimString
syn match vimString "'\([^']*\\'\)*[^']*'" contains=vimEscapedChar
syn match vimString '"\([^"]*\"\)*[^"]*"' contains=vimEscapedChar
syn match vimString "\<\d\(\.\d*\)*\>"

hi vimLineComment ctermfg=green
syn match vimLineComment "^\s*\".*"

hi vimCall ctermfg=blue
hi vimCallAutoload ctermfg=red
syn match vimCall "\<\(\(\w:\)\?\w\+\.\)\?\w\+\ze("
syn match vimCallAutoload "\(\w:\)\?\w\+#\w\+\>"

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
