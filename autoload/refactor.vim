" NOTE: Does not work :(
" USE:
" 1) Use vimgrep to find all instances of a given word
" 2) Modify found lines in quickfix window
" 3) Call WriteQuickfix()

fun! refactor#ApplyQuickfixChanges()
    if bufname('.') !=# "__output__"
        echoerr "You should be in output buffer"
        return
    endif

    let changes = s:readChanges()
    call s:applyChanges(changes)
    call s:updateBuffers(changes)
endfun

fun! refactor#grep(word, filepattern)
    let recursive = (a:filepattern == "*") ? ' -R ' : ''
    let lines = system("grep -n " . recursive . a:word)
    let lines = substitute(lines, ':', '|', 'g')
    call OutputText(lines)

    call SwitchToOutputWindow()
    set ft=qf
endfun

fun! s:readChanges()
    let changes = {}
    for i in range(1, line('.'))
        let [file, nr, line] = split(getline(i), '|')
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

        for change in a:changes[file]
            let [nr, ch] = change
            let lines[nr - 1] = ch
        endfor

        call writefile(lines, file)
    endfor
endfun

fun! s:updateBuffers(changes)
    for file in keys(a:changes)
        if bufnr(file) != -1
            exe "buffer " . bufnr(file)
            edit
        endif
    endfor
endfun
