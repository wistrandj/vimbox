let b:did_indent=1

set noautoindent
set nosmartindent
set softtabstop=2
set shiftwidth=2
set indentexpr=<SID>YamlIndent(v:lnum)

function! s:YamlIndent(lnum)
    let prevnonblank = prevnonblank(a:lnum)
    if (a:lnum - prevnonblank > 3)
        return 0
    endif
    let prevline=getline(prevnonblank)
    let indent=len(substitute(prevline, '\S.*', '', ''))

    if (prevline =~# '^\s*-.*:')
        return len(substitute(prevline, '\s*-\s*\zs.*', '', ''))
    elseif (prevline =~# '^\s*-\s*\w*$')
        return len(substitute(prevline, '-.*', '', ''))
    elseif (prevline =~# ':')
        return indent + &sw
    endif
    return indent
endfunction
