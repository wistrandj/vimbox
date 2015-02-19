syntax clear

syn match Title '\\\w*'
syn match Title '{\\[^}]*}'
syn match LineNr '^\s*\\\w*{[^}]\+}'

syn match Concealed '\\item' conceal cchar=*

set concealcursor=nvi
syn match MoreMsg '\$[^$]*\$'
