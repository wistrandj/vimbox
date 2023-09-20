command! Paste call <SID>PasteFromSystemClipboard()
nnoremap <Plug>Vimbox_PasteFromSystemClipboard :call <SID>PasteFromSystemClipboard()<CR>

function! s:HasPbpaste()
    let result = system('which pbpaste')
    let has_pbpaste = system('which pbpaste')
    if stridx(has_pbpaste, 'not found') < 0
        return v:true
    else
        return v:false
    endif
endfunction

function! s:PasteFromSystemClipboard()
    if s:HasPbpaste()
        exec printf('r!pbpaste')
        echom "[VIMBOX] Paste from system clipboard"
    else
        echoerr '[VIMBOX] Pbpaste missing'
    endif
endfunction

