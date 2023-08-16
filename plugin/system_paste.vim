
function s:PasteTextAfterCursor()
"    if system('which -s pbpaste')
"    else if system('which -s xsel')
"        let text = system('xsel -b')
"        exec printf('norm' . text)
"    endif
    echom "NOT IMPLEMENTED YET!!!!!"
endfunction

nnoremap <Plug>VimboxSystemPaste_PasteTextAfterCursor() :call <SID>PasteTextAfterCursor()<CR>

