if exists('g:no_syntax')
    finish
endif
let b:current_syntax = 'c'

hi FunctionLine cterm=italic
hi ClassLine cterm=underline
call matchadd("FunctionLine", '^\w\&\(public:\|private:\|protected\|class\)\@!.*')
call matchadd("ClassLine", '^\(class\|struct\|enum\).*')

" Modifiers
hi cmodifiers ctermfg=red
syn keyword cmodifiers static volatile const extern register
" Data
hi cdata ctermfg=yellow
hi csizeof ctermfg=yellow
hi csizeof2 ctermfg=darkyellow
" syn keyword cdata enum struct union typedef class
syn keyword csizeof sizeof assert while for return if else switch break
syn keyword csizeof2 case

" Single chars
hi ptrchar ctermfg=red
hi logicchar ctermfg=darkyellow
hi mathchar ctermfg=yellow
hi comma ctermfg=green
syn match ptrchar "&"
syn match logicchar "||\|&&\|=\|<\|>\|==\|!="
syn match mathchar "+\|-\|\*\|%\|\/\ze[^\*\/]"
syn match comma ","

" Struct & Union members
hi structMember ctermfg=blue
syn match structMember "\(->\|\.\)\w*" contains=structMemberName

" Templates
hi link templateType logicchar
syn match templateType "<.*>"

" Strings
hi variable ctermfg=darkred
hi formatSpecifier ctermfg=yellow
syn match variable "\"\(\(\\\"\)\|[^"]\)*\"" contains=formatSpecifier
syn match variable "'\\.'"
syn match formatSpecifier "%-\?\d*\(\.\d\+\)\?\w\+" containedin=variable

" Function call
hi fn ctermfg=darkblue
hi coloncolon ctermfg=NONE
syn match coloncolon "::" contained
syn match fn "\(\w\+::\~\?\)\?\w\+\ze(.*)" contains=coloncolon
