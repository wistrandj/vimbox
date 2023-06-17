if exists('g:no_syntax')
    finish
endif
let b:current_syntax = 'zig'

hi zig_comment ctermfg=lightgreen
hi zig_fill_in ctermfg=black ctermbg=darkyellow

syn match zig_comment '//.*'
syn match zig_fill_in '???'

syn keyword zig_comment pub fn
