" Note: duplicate with after/syntax/zig.vim.

hi zig_keyword ctermfg=darkgreen cterm=bold
hi zig_control_flow ctermfg=red cterm=bold
hi zig_comment ctermfg=darkgray

syn keyword zig_keyword pub fn test const var true false comptime if else orelse for switch struct enum type while undefined inline and or
syn keyword zig_control_flow try defer return catch break unreachable continue
syn match zig_comment '//.*'
syn match zig_keyword '@\w\+'

