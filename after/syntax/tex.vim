syntax clear

" Comments
syn match Comment '% .*' contains=Todo
syn keyword Todo TODO

" Commands: \cmd
syn match Title '\\\w*'
syn match Title '{\\[^}]*}'
" ^\cmd{abc}
syn match LineNr '^\s*\\\w*{[^}]\+}'

syn match Concealed '\\item' conceal cchar=*

set concealcursor=nvi

" Math mode
syn match MoreMsg '\$[^$]*\$'
