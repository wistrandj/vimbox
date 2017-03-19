
let s:statusline = []

hi StatuslineHilight cterm=reverse ctermfg=white ctermbg=darkred

function! statusline#StatusLineFunction()
    " return "(buf %n) %y %#StatuslineHilight#%-5.50f%*%=col %c|line %l/%L"
    " TODO: Remove code below :D register thingy and lines() are good

    let s:statusline = []
    call s:add("%f", "StatuslineHilight")
    call s:add('%{git#statusline()}')
    call s:add("%=")
    call s:add("col")
    call s:add("%c", "StatuslineHilight")
    call s:add("|")
    call s:add("line")
    call s:add("%l", "StatuslineHilight")
    call s:add("/%L")
    " call s:add("col %c%*|line %l/%L")

    return join(reverse(s:statusline), ' ')
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
