
function! BuildColor(name, fg, bg)
    return printf('hi %s ctermfg=%s ctermbg=%s', a:name, a:fg, a:bg)
endfunction
