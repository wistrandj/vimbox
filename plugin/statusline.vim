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

fun! statusline#StatusLineFunction()
    let flags = s:StatusLineFlags()
    let lines = s:StatusLineLines()
    let pages = s:CursorPosition()
    return "(buf %n) %y %f " . flags . " %= " . lines . " " . pages
endfun
