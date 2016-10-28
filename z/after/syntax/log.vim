hi _at ctermfg=red
syn match _at "^\tat \zs.*\ze("

hi _linenr ctermfg=cyan
syn match _linenr ":\d\+" contained

hi _file ctermfg=green
syn match _file "[A-Z][A-Za-z0-9]*\.java:\d\+" contains=_linenr

hi _warning ctermfg=yellow
hi _error ctermfg=red
syn match _warning "^\[WARNING\]"
syn match _error "^\[ERROR\]"
