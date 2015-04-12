syntax clear

" Comments
syn match Comment '% .*' contains=Todo
syn keyword Todo TODO

" Commands: \cmd
syn match Title '\\\w*'
syn match Title '{\\[^}]*}'
" ^\cmd{abc}
syn match LineNr '\s*\\\w*{[^}]\+}'

syn match Concealed '\\item' conceal cchar=*
syn match Concealed '\\subitem' conceal cchar=-

set concealcursor=nvi

" Math mode
hi MathMode ctermfg=darkgreen
hi MathModeRegion ctermfg=green
hi MathModeRegionBlock ctermfg=darkgreen
syn match MathMode '\$[^$]*\$'

syn region MathModeRegion
    \ start='\\begin{equation\*\?}'
    \ end='\\end{equation\*\?}'
    \ contains=MathModeRegionBlock
syn region MathModeRegionBlock
    \ start='\\begin{equation\*\?}\zs'
    \ end='\ze\\end{equation\*\?}'
    \ containedin=MathModeRegion
    \ contains=Comment

hi AlignAmpersand ctermfg=blue
syn match AlignAmpersand '&\|\\\\' containedin=MathModeRegionBlock

syn region MathModeRegion
    \ start='\\begin{align\*\?}'
    \ end='\\end{align\*\?}'
    \ contains=MathModeRegionBlock
syn region MathModeRegionBlock
    \ start='\\begin{align\*\?}\zs'
    \ end='\ze\\end{align\*\?}'
    \ containedin=MathModeRegion
    \ contains=Comment,AlignAmpersand
" These could be combined v^
syn region MathModeRegion
    \ start='\\begin{matrix\*\?}'
    \ end='\\end{matrix\*\?}'
    \ contains=MathModeRegionBlock
syn region MathModeRegionBlock
    \ start='\\begin{matrix\*\?}\zs'
    \ end='\ze\\end{matrix\*\?}'
    \ containedin=MathModeRegion
    \ contains=Comment,matrixAmpersand

" Tabular
