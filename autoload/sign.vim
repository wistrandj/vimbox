hi UserSignBad ctermfg=Magenta
hi UserSignGood ctermfg=Green
hi UserSignInfo ctermfg=Brown
sign define UserSignBad text=>> texthl=UserSignBad
sign define UserSignGood text=++ texthl=UserSignGood
sign define UserSignInfo text=>> texthl=UserSignInfo

let s:SignNames = { 'bad': 'UserSignBad', 'good': 'UserSignGood', 'info': 'UserSignInfo' }
let s:RunningCounter = 5001

function sign#CommandCompletion(ArgLead, CmdLine, CursorPos)
    return keys(s:SignNames) + ['delete', 'clear']
endfunction


function sign#PlaceCommand(line1, line2, bang, ...)
    if !exists('b:signs_placed')
        let b:signs_placed = 1
        let b:lines_byid = {}
        let b:line2id = {}
    endif

    let arg = ''
    if a:0 != 0
        let arg = a:1
    endif

    let clearBuffer = a:bang || index(['c', 'cl', 'clear'], arg) != -1
    let deleteSignOnLine = index(['d', 'del', 'delete'], arg) != -1
    let signName = get(s:SignNames, arg, s:SignNames['info'])

    if clearBuffer
        call sign#UnplaceIds(keys(b:lines_byid))
    elseif deleteSignOnLine
        if has_key(b:line2id, line('.'))
            let id = b:line2id[line('.')]
            call sign#UnplaceIds([id])
        endif
    else
        " NOTE: `line2` is 1, if there wasn't range given
        call sign#Place(a:line1, (a:line2 == 1) ? a:line1 : a:line2 , signName)
    endif
endfunction


function sign#Place(lft, rgh, signName)
    let colliding_ids = {}
    for line in range(a:lft, a:rgh)
        if has_key(b:line2id, line)
            let id = b:line2id[line]
            let colliding_ids[id] = 1
        endif
    endfor
    call sign#UnplaceIds(keys(colliding_ids))

    let id = s:RunningCounter
    let s:RunningCounter += 1
    let b:lines_byid[id] = []
    for line in range(a:lft, a:rgh)
        let cmd = printf('sign place %d line=%d name=' . a:signName. ' buffer=%d', id, line, bufnr('%'))
        exe cmd
        let b:line2id[line] = id
        let b:lines_byid[id] += [line]
    endfor
endfunction


function sign#UnplaceIds(ids)
    for id in a:ids
        for line in b:lines_byid[id]
            " NOTE: This sign unplacing removes only the first sign with that id
            let cmd = printf('sign unplace %d', id)
            exe cmd
            unlet b:line2id[line]
        endfor
        unlet b:lines_byid[id]
    endfor
endfunction


function sign#Debug()
    if !exists('s:signs_placed')
        echom "No signs placed yet"
        return
    else
        echo s:RunningCounter
        echo b:lines_byid
        echo b:line2id
    endif
endfunction
