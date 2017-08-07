if exists('g:no_syntax')
    finish
endif
syntax clear
let b:current_syntax = 'python'

hi PythonKeyword ctermfg=yellow
hi PythonImport ctermfg=cyan
hi PythonLogicOperators ctermfg=white cterm=bold
hi PythonValue ctermfg=red
hi PythonConstant ctermfg=white cterm=bold
hi PythonStandardFunction ctermfg=magenta
hi PythonComment ctermfg=darkmagenta cterm=none
hi PythonFunctioncall ctermfg=blue
hi PythonConstructioncall ctermfg=green
hi PythonList ctermfg=white cterm=bold
hi PythonSelf ctermfg=none

syn keyword PythonKeyword def class pass
syn keyword PythonImport from import
syn match PythonSelf "^\s*self"
syn keyword PythonLogicOperators for try except if elif else while in not
syn region PythonValue start='u\?"' skip='\\"' end='"'
syn region PythonValue start="u\?'" skip="\\'" end = "'"
syn match PythonValue "\<\d\+\(\.\d\+\)\?"
syn keyword PythonConstant None True False list
syn keyword PythonStandardFunction list str len


syn match PythonComment "^\s*#.*$"
"syn match PythonFunctioncall ")*"
"syn match PythonFunctioncall "\<\w\+("
syn match PythonConstructioncall "\<[A-Z]\w*\ze("

syn match PythonList "\[\|\]\|{\|}"
