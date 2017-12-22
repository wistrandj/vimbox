
function! debug#GetSyntaxItemUnderCursor()
    return synIDattr(synID(line('.'), col('.'), 1), 'name')
endfunction

function! debug#PrettyPrint_list(args)
    if (type(a:args) == type([]) && !empty(a:args) && type(a:args[0]) == type({}))
        for arg in a:args
            call s:PrettyPrint_aux(arg, 0)
            echo "----------------------------------------"
        endfor
    else
        call s:PrettyPrint_aux(a:args, 0)
    endif
endfunction

function! s:PrettyString(str, depth, newline)
    let space = printf('%' . a:depth . 's', '')
    " let text = (type(a:str) == type("")) ? a:str : string(a:str)
    let text = a:str
    if a:newline
        echo space . text
    else
        echon space . text
    endif
endfunction

function! s:PrettyPrint_aux(ds, depth)
    if (a:depth > 16) | return | endif
    let true = 1
    let false = 0
    let T = type(a:ds)
    if (T == type({}))
        let maxkey = max(map(copy(keys(a:ds)), 'len(string(v:val))'))
        for key in keys(a:ds)
            call s:PrettyString(printf('%-' . maxkey. 's', key . ':'), a:depth, true)
            call s:PrettyPrint_aux(a:ds[key], a:depth + 4)
        endfor
    elseif (T == type([]))
        if (len(a:ds) > 6)
            echo '['
            echon string(a:ds[0])
            echon string(a:ds[1])
            echon string(a:ds[2])
            echon '..., '
            echon string(a:ds[-3])
            echon string(a:ds[-2])
            echon string(a:ds[-1])
            echo ']'
        else
            echo string(a:ds)
        endif
    elseif (T == type(""))
        let s = substitute(a:ds, '\n', '\\n', 'g')
        if len(s) > 50
            echon string(s[:47]) . '...'
        else
            echon string(s)
        endif
    else
        echon string(a:ds)
    endif
endfunction

