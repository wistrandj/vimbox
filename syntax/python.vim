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
syn keyword PythonStandardFunction abs all any ascii bin bool bytearray bytes callable chr classmethod compile complex delattr dict dir divmod enumerate eval exec filter float format frozenset getattr globals hasattr hash help hex id input int isinstance issubclass iter len list locals map max memoryview min next object oct open ord pow print property range repr reversed round set setattr slice sorted staticmethod str sum super tuple type vars zip
syn keyword PythonStandardFunction __all__ __args__ __author__ __bases__ __builtin__ __builtins__ __cached__ __call__ __class__ __copy__ __credits__ __date__ __decimal_context__ __deepcopy__ __dict__ __doc__ __exception__ __file__ __flags__ __ge__ __getinitargs__ __getstate__ __gt__ __import__ __importer__ __init__ __ispkg__ __iter__ __le__ __len__ __loader__ __lt__ __main__ __module__ __mro__ __name__ __package__ __path__ __pkgdir__ __return__ __safe_for_unpickling__ __setstate__ __slots__ __temp__ __test__ __version__
syn match PythonList "\[\|\]\|{\|}"

" Comments
syn match PythonComment "^\s*#.*$"
syn match PythonConstructioncall "\<[A-Z]\w*\ze("
