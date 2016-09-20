hi _hidden ctermfg=gray
hi _hilighted ctermbg=yellow ctermfg=white
hi _hilighted2 ctermbg=blue ctermfg=white
hi _hilighted3 ctermfg=yellow
" syn match _hidden "<\(\w*\)\([^>]*\)\?>.*<\1>"
syn match _hidden "<\([^>]*\)>.*<\1>"
syn match _hilighted "<\/\?build>"
syn match _hilighted "<\/\?dependencies>"
syn match _hilighted2 "<\/\?plugins>"
syn match _hilighted3 "<\/\?plugin>"
syn match _hilighted3 "<\/\?dependency>"

" tab chars
hi SpecialKey ctermfg=darkgray

hi xmlTag ctermfg=gray
hi xmlTagName ctermfg=gray
hi xmlEndTag ctermfg=gray
