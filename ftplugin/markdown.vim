nnoremap <buffer> <leader>h1 :call <SID>Header('=')<CR>
nnoremap <buffer> <leader>h2 :call <SID>Header('-')<CR>

if exists('s:loaded')
    finish
endif | let s:loaded = 1

function s:Header(underline)
    let underline = substitute(getline('.'), '.', a:underline, 'g')
    call append('.', underline)
endfunction
