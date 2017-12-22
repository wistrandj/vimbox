let g:vimrc_sign_counter = 1001
hi _signhl ctermfg=blue ctermfg=red
sign define tmpsign text=>> texthl=_signhl

function! sign#SetLine(line)
    call <SID>SetSign(a:line, a:line)
endfunction

" Leave signs on lines between `lft` and ´rgh´
"
function! sign#SetRange(lft, rgh)
    for i in range(a:lft, a:rgh)
        let id = g:vimrc_sign_counter
        let g:vimrc_sign_counter = g:vimrc_sign_counter + 1
        let cmd = printf('sign place %d line=%d name=tmpsign file=%s', id, i, expand('%:p'))
        exe cmd
    endfor
endfunction

