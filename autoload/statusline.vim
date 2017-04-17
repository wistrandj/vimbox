
let s:statusline = []
let s:package_cache_by_buffer = {}

hi StatuslineHilight cterm=reverse ctermfg=white ctermbg=darkred

function! statusline#StatusLineFunction()
    " return "(buf %n) %y %#StatuslineHilight#%-5.50f%*%=col %c|line %l/%L"
    " TODO: Remove code below :D register thingy and lines() are good

    let s:statusline = []
    call s:add(":b%n |")
    call s:add("%t", "StatuslineHilight")
    call s:add("%<%{Vimrc_statusline_get_package()}")
    call s:add("%=")
    call s:add('%y')
    call s:add('%{git#statusline()}')
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

function! s:join_by_color(text1, text2, color)
    return printf('%s%%#%s#%s%%*', a:text1, a:color, a:text2)
endfunction

function! Vimrc_statusline_get_package()
    let buf = bufnr('%')
    if has_key(s:package_cache_by_buffer, buf)
        return s:package_cache_by_buffer[buf]
    endif

    if &ft == 'java'
        let ln = search('^package ')
        if (ln != -1)
            let pack = substitute(getline(ln), '.*package *\(.*\);$', '\1', '')
            let pack = substitute(pack, '\.', ' ', 'g')
            let s:package_cache_by_buffer[buf] = '('.pack.')'
            return pack
        endif

    elseif &ft == 'python'
        let pkg = []
        let dirs = split(expand('%:p:h'), '/')
        while !empty(dirs)
            let init = join(['/'] + dirs + ['__init__.py'], '/')
            echom init
            if filereadable(init)
                call insert(pkg, dirs[-1])
                call remove(dirs, -1)
            else
                break
            endif
        endwhile
        let str = empty(pkg) ? '' : '('.join(pkg, '.').')'
        let s:package_cache_by_buffer[buf] = str
        return str
    endif

    return expand('%:h')
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
