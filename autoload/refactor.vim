
" USE:
" 1) Use vimgrep to find all instances of a given word
" 2) Modify found lines in quickfix window
" 3) Call WriteQuickfix()

fun! refactor#ApplyQuickfixChanges()
    if &buftype != "quickfix"
        echoerr "refactor#readChanges(): Use quickfix window"
        return {}
    endif

    let changes = s:readChanges()
    call s:applyChanges(changes)
endfun

fun! s:readChanges()
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
        echo "file: " . file
        let lines = readfile(file)

        for change in a:changes[file]
            let [nr, ch] = change
            echo "    change: " . nr . " : " . ch
            let lines[nr - 1] = ch
        endfor

        call writefile(lines, file)
    endfor
endfun
