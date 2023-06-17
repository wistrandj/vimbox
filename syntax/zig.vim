" Note: duplicate with after/syntax/zig.vim.

hi zig_keyword ctermfg=darkgreen cterm=bold
hi zig_comment ctermfg=darkgray

syn keyword zig_keyword pub fn test try const var true false defer
syn match zig_comment '//.*'
syn match zig_keyword '@\w\+'

