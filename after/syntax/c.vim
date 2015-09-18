nnoremap <F1> :source "/home/jasu/.vim/bundle/mystuff/after/syntax/c.vim"<CR>

syn clear
let b:current_syntax = 'c'

" These two should belong to function call block but these are low priority
hi fnWord ctermfg=white
syn match fnWord "\w\+" containedin=fnParen contained

" Keywords
" Flow
hi flow ctermfg=yellow
syn keyword flow break case default do if else for goto return switch while continue
" Types
hi ctypes ctermfg=green
hi cExtraTypes ctermfg=darkgreen
syn keyword ctypes int short unsigned signed float double char void
syn keyword cExtraTypes FILE
syn match ctypes "u\?int\d\+_t"
" Modifiers
hi cmodifiers ctermfg=darkred
syn keyword cmodifiers static volatile const extern register 
" Data
hi cdata ctermfg=darkblue
hi csizeof ctermfg=yellow
syn keyword cdata enum struct union typedef
syn keyword csizeof sizeof
" Include
hi cinclude ctermfg=darkmagenta
hi cincludeFile ctermfg=red
hi badContinuation ctermbg=red
hi link cmacro cinclude
syn match cmacro "^\s*#.*" contains=comment
syn region cmacro start="^\s*#define.*\\\n" skip="\\$" end="$"
syn match cinclude "#include .*" contains=cincludeFile
syn match cincludeFile "<.*>" containedin=cinclude contained
syn match cincludeFile "\".*\"" containedin=cinclude contained

syn region cmacro start="#if 0" end="#endif"

" Single chars
hi ptrchar ctermfg=red
syn match ptrchar "\*\|&"
hi logicchar ctermfg=darkyellow
syn match logicchar "||\|&&\|=\|<\|>\|==\|!="
hi link mathchar logicchar
syn match mathchar "+\|-\|\*\|\/\|%"

" Struct & Union members
hi structMember ctermfg=blue
hi structMemberName ctermfg=blue
syn match structMember "\(->\|\.\)\w\+" contains=structMemberName
syn match structMemberName "\(->\|\.\)\zs\w\+" containedin=structMember contained

" Variables
hi variable ctermfg=darkred
syn keyword variable NULL stdout stdin stderr EXIT_FAILURE EXIT_SUCCESS M_PI
syn match variable "\<\d\+[fL]\?"
syn match variable "\d\+\.\d*[fL]\?"
syn match variable "\"\(\(\\\"\)\|[^"]\)*\""
syn match variable "'.'"
syn match variable "'\\0'"
syn match variable "'\\n'"

" Function call
hi fn ctermfg=cyan
hi fn1 ctermfg=darkblue
hi fnParen ctermfg=darkmagenta
hi fnParenMini ctermfg=magenta
hi fnArg ctermfg=blue
hi fnComma ctermfg=yellow
syn match fn "\w\+\ze(.*)" contains=fnParenMini,fnParen
syn match fn1 "\w\+\ze(.*)" contains=fnParenMini,fnParen contained
syn match fnParen "(.*)" contained contains=ALL
syn match fnComma "," contained containedin=fn
syn match fnparenMini "()"

" Comment
hi comment ctermfg=grey
hi commentKeyword ctermfg=yellow
syn match comment "\/\/.*"
syn region comment start="\/\*" end="\*\/"
syn keyword commentKeyword TODO FIXME XXX containedin=comment
