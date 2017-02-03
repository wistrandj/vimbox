
let s:statusline = []
" let s:custom_function

syn clear StatuslineHilight
hi StatuslineHilight cterm=reverse ctermfg=white ctermbg=darkred

function! statusline#StatusLineFunction()
    return "(buf %n) %y %#StatuslineHilight#%-5.50f%* %c/%l/%L"
    " TODO: Remove code below :D register thingy and lines() are good

    let s:statusline = []
    call s:add("(buf %n) %y")
    call s:add("%f")
    call s:add(s:flags())
    " call s:add('%{git#statusline()}')
    if exists("s:custom_function")
        call s:add(s:custom_function())
    endif
    if (exists("g:makefix_loaded"))
        call s:add(MakefixStatusline())
    endif
    call s:add("%=")
    call s:add(s:lines())
    call s:add(s:cursor_position())

    return join(reverse(s:statusline), ' ')
endfunction

function! statusline#CustomText(fn)
    if type(a:fn) != type(function("tr"))
        echoerr "statusline#CustomText: Argument must be a funcref that returns a string"
        return
    endif

    let s:custom_function = a:fn
endfunction

" === Simple interface for building statusline ================================

function! s:add(text, ...)
    let higrp = (a:0 > 0) ? a:1 : ''
    if !empty(higrp)
        call insert(s:statusline, printf('%%#%s#%s%%*', higrp, a:text))
    else
        call insert(s:statusline, a:text)
    endif
endfunction

" === Building block ==========================================================

function! s:cursor_position()
    if (line('w0') == 1 && line('w$') == line('$'))
        return "[All]"
    end

    let winh = winheight(0)
    let pages = line('$') / winh + 1

    if (line('w0') == 1)
        return "[Top/" . pages . "]"
    elseif (line('w$') == line('$'))
        return "[Bottom/" . pages . "]"
    end

    let current = line('.') / winh + 1
    return "[" . current . "/" . pages ."]"
endfunction

function! s:lines()
    return col('.') . "'" . line('.') . "/" . line('$')
endfunction

function! s:flags()
    return "[%M%R%H%W]"
endfunction

function! s:view_regs(names, len)
    let s = ""
    let regs = map(a:names, 's:strip_reg(getreg(v:val), a:len)')
    for i in range(0, len(regs) - 1)
        let s .= (0 < i && i < len(regs) ? ',': '') . regs[i]
    endfor
    return '[' . s . ']'
endfunction

function! s:strip_reg(line, len)
    let fst = match(a:line, "[^ ]")
    let lst = fst + a:len

    while a:line[lst] == " "
        let lst -= 1
    endwhile

    let s = a:line[(l:fst):(l:lst)]
    return substitute(s, "[^a-zA-Z0-9 ]", '', '')
endfunction
