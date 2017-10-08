if exists('g:no_syntax')
    finish
endif
syntax clear
let b:current_syntax = 'python'

hi PythonComment ctermfg=darkmagenta cterm=none
hi PythonConstant ctermfg=white cterm=bold
hi PythonProperty ctermfg=white cterm=bold
hi PythonConstructioncall ctermfg=green
hi PythonImport ctermfg=cyan
hi PythonKeyword1 ctermfg=yellow
hi PythonKeyword2 ctermfg=white cterm=bold
hi PythonList ctermfg=white cterm=bold
hi PythonLogicOperators ctermfg=white cterm=bold
hi PythonSelf ctermfg=none
hi PythonStandardFunction ctermfg=magenta
hi PythonValue ctermfg=red

" Keywords and build-in functions
syn keyword PythonKeyword1 def for raise return try while yield
syn keyword PythonKeyword2 if else elif break continue exec pass with try except finally local global
syn keyword PythonImport from import
syn match PythonSelf "^\s*self"
syn keyword PythonConstant and as del in is not or

" Special case: lambda
hi PythonLambda cterm=none
hi PythonLambda1 ctermfg=yellow cterm=bold
syn region PythonLambda matchgroup=PythonLambda1 start="\<lambda" end=':\|$' display

" Class
hi PythonClass cterm=none
syn region PythonClass matchgroup=PythonKeyword1 start=/^class/ matchgroup=PythonConstructioncall  end=/\<\w*:\|$/

" Property tag
syn match PythonProperty "^\s*@\w*"

" Values
syn region PythonValue start='u\?"' skip='[^\\]\\"' end='"' display
syn region PythonValue start='u\?"""' skip='[^\\]\\"' end='"""' display
syn region PythonValue start="u\?'" skip="[^\\]\\'" end = "'" display
syn match PythonValue "\<\d\+\(\.\d\+\)\?"
syn keyword PythonConstant None True False
syn match PythonStandardFunction "\<\(__import__\|abs\|all\|any\|ascii\|bin\|bool\|bytearray\|bytes\|callable\|chr\|classmethod\|compile\|complex\|delattr\|dict\|dir\|divmod\|enumerate\|eval\|exec\|filter\|float\|format\|frozenset\|getattr\|globals\|hasattr\|hash\|help\|hex\|id\|input\|int\|isinstance\|issubclass\|iter\|len\|list\|locals\|map\|max\|memoryview\|min\|next\|object\|oct\|open\|ord\|pow\|print\|property\|range\|repr\|reversed\|round\|set\|setattr\|slice\|sorted\|staticmethod\|str\|sum\|super\|tuple\|type\|vars\|zip\)\ze("
syn match PythonList "\[\|\]\|{\|}"

" Comments
syn match PythonComment "^\s*#.*$"
syn match PythonConstructioncall "\<[A-Z]\w*\ze("
