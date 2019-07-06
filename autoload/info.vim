let s:showlist = {}

function! info#Info(title)
    if !has_key(s:showlist, a:title)
        return
    endif

    if has_key(s:showlist, a:title)
        let Func = s:showlist[a:title]
        call Func()
    else
        echom 'Missing title ' . a:title
    endif
endfunction

function! info#Register(title, func)
    " NOTE: Vim 8.0+
    if type(a:title) != v:t_string || type(a:func) != v:t_func
        echoerr 'Invalid parameters'
    endif

    let s:showlist[a:title] = a:func
endfunction

function! info#Complete(ArgLead, CmdLine, CursorPos)
    let matching = []
    for key in keys(s:showlist)
        let pattern = printf('%s.*', a:ArgLead)
        if (key =~ pattern)
            call insert(matching, key)
        endif
    endfor
    return matching
endfunction


