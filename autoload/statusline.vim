fun! s:CursorPosition()
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

fun! s:StatusLineLines()
    return col('.') . "'" . line('.') . "/" . line('$')
endfun

fun! s:StatusLineFlags()
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

fun! s:Yanked(num, len)
    " TODO:
    let yank_list = []
    for i in range(1, a:num)
        let line = s:strip_reg(getreg(i), a:len)
        call add(yank_list, line_)
    endfor
    return '[' . join(yank_list, "|") . ']'
endfun

fun! s:view_regs(names)
    let regs = map(names, 's:strip_reg(getreg(v:val))')
    exe 'let s = ' . join(regs, '|')
    return s
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

fun! statusline#StatusLineFunction()
    let flags = s:StatusLineFlags()
    let lines = s:StatusLineLines()
    let pages = s:CursorPosition()
    let git_branch = s:Git()
    let yanked = s:Yanked(3, 5)

    if (git_branch) != ""
        let git_branch = "[G: " . git_branch . "]"
    endif

    let left = "(buf %n) %y %f " . flags . " " . git_branch . yanked
    let right = lines . " " . pages
    let stat = left . "%=". right
    return stat
    return join(lst, "")
endfun
