
let s:statusline = ""

fun! statusline#StatusLineFunction()
    let s:statusline = ""
    let git_branch = s:Git()
    let git_branch = (git_branch == '') ? '' : ('[G: ' . git_branch . ' ]')
    call s:add("(buf %n) %y %f")
    call s:add(s:flags(), "Question")
    call s:add(git_branch)
    call s:add(s:yanked(3, 5))
    call s:add("%=")
    call s:add(s:lines())
    call s:add(s:cursor_position())
    return s:statusline
endfun

" === Simple interface for building statusline ================================

fun! s:add(text, ...)
    let higrp = (a:0 > 0) ? a:0 : ''
    if !empty(higrp)
        let s:statusline .= "%#" . higrp. "#"
        let s:statusline .= a:text . " "
        let s:statusline .= "%#StatusLine#"
    else
        let s:statusline .= a:text . " "
    endif
endfun

" === Building block ==========================================================

fun! s:cursor_position()
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
endfun

fun! s:lines()
    return col('.') . "'" . line('.') . "/" . line('$')
endfun

fun! s:flags()
    return "[%M%R%H%W]"
endfun

fun! s:Git()
    let s:git_available = git#git_available()

    if !s:git_available
        return ""
    else
        return git#get_current_branch()
    endif
endfun

fun! s:yanked(num, len)
    let regs = [0, 1, 2, '-']
    return s:view_regs(regs, a:len)
endfun

fun! s:view_regs(names, len)
    let s = ""
    let regs = map(a:names, 's:strip_reg(getreg(v:val), a:len)')
    for i in range(0, len(regs) - 1)
        let s .= (0 < i && i < len(regs) ? ',': '') . regs[i]
    endfor
    return '[' . s . ']'
endfun

fun! s:strip_reg(line, len)
    let fst = match(a:line, "[^ ]")
    let lst = fst + a:len

    while a:line[lst] == " "
        let lst -= 1
    endwhile

    let s = a:line[(l:fst):(l:lst)]
    return substitute(s, "[^a-zA-Z0-9 ]", '', '')
endfun
