
" USE:
" 1) Use vimgrep to find all instances of a given word
" 2) Modify found lines in quickfix window
" 3) Call WriteQuickfix()


fun! s:readChanges()
    if &buftype != "quickfix"
        echoerr "refactor#readChanges(): Use quickfix window"
        return {}
    endif

    let changes = {}
    for i in range(1, line('.'))
        let [file, nr, line] = split(getline('.'), '|')
        let nr = str2nr(substitute(nr, '^([0-9]\+).*', '\1', ''))
        let line = line[1:]

        if !has_key(changes, file)
            let changes[file] = []
        endif

        call add(changes[file], [nr, line])
    endfor

    return changes
endfun

fun! s:applyChanges(changes)
    for file in keys(a:changes)
        let lines = readfile(file)

        for [nr, ch] in a:changes[file]
            let lines[nr] = ch
        endfor

        call writefile(lines, file)
    endfor
endfun
