syntax clear

" Comments
syn match Comment '% .*' contains=Todo
syn keyword Todo TODO

" Commands
syn match Title '\\\w*'
syn match Title '{\\[^}]*}'
syn match LineNr '\s*\\\w*\*\?{[^}]\+}'
syn match Concealed '\\item' conceal cchar=*
syn match Concealed '\\subitem' conceal cchar=-
set concealcursor=nvi

" === Math mode ===============================================================
hi MathMode ctermfg=darkgreen
hi MathModeRegion ctermfg=darkgray
hi MathModeRegionBlock ctermfg=gray
hi MathDollar cterm=none ctermfg=yellow
syn match MathDollar '\$' contained
syn match MathMode '\$[^$]*\$' contains=MathDollar

" Items in mathmode
hi LabelMatch ctermfg=red
hi NoticeThisChar ctermfg=red
hi AlignAmpersand ctermfg=blue
syn match LabelMatch "\\label{.*}"
syn match NoticeThisChar "\(=\|<\|>\|\\leq\|\\geq\|\\neq\|\\\w*arrow\)"
syn match AlignAmpersand '&\|\\\\' containedin=MathModeRegionBlock


syn region MathModeRegion
    \ start='\\begin{equation\*\?}'
    \ end='\\end{equation\*\?}'
    \ contains=MathModeRegionBlock
syn region MathModeRegionBlock
    \ start='\\begin{equation\*\?}\zs'
    \ end='\ze\\end{equation\*\?}'
    \ containedin=MathModeRegion
    \ contains=Comment,LabelMatch,NoticeThisChar
syn region MathModeRegion
    \ start='\\begin{\(align\)\*\?}'
    \ end='\\end{align\*\?}'
    \ contains=MathModeRegionBlock
syn region MathModeRegionBlock
    \ start='\\begin{align\*\?}\zs'
    \ end='\ze\\end{align\*\?}'
    \ containedin=MathModeRegion
    \ contains=Comment,AlignAmpersand,LabelMatch,NoticeThisChar
syn region MathModeRegion
    \ start='\\begin{matrix\*\?}'
    \ end='\\end{matrix\*\?}'
    \ contains=MathModeRegionBlock
syn region MathModeRegionBlock
    \ start='\\begin{matrix\*\?}\zs'
    \ end='\ze\\end{matrix\*\?}'
    \ containedin=MathModeRegion
    \ contains=Comment,matrixAmpersand,LabelMatch,NoticeThisChar
