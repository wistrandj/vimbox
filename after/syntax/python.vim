if exists('g:no_syntax')
    finish
endif
syntax clear
let b:current_syntax = 'python'

hi PythonKeyword ctermfg=yellow
hi PythonImport ctermfg=cyan
hi PythonLogicOperators ctermfg=white cterm=bold
hi PythonValue ctermfg=red
hi PythonComment ctermfg=darkmagenta cterm=none
hi PythonFunctioncall ctermfg=blue
hi PythonConstructioncall ctermfg=green
hi PythonList ctermfg=darkred
hi PythonSelf ctermfg=red

syn keyword PythonKeyword def class
syn keyword PythonImport from import
syn match PythonImport "^\s*self"
syn keyword PythonLogicOperators for try except if elif else while
syn region PythonValue start='"' end = '"'
syn match PythonValue "\<\d\+\(\.\d\+\)\?"


syn match PythonComment "^\s*#.*$"
"syn match PythonFunctioncall ")*"
"syn match PythonFunctioncall "\<\w\+("
syn match PythonConstructioncall "\<[A-Z]\w*\ze("

syn match PythonList "\[\|\]\|{\|}"
