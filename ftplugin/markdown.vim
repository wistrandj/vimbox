function! s:Header(underline)
    let underline = substitute(getline('.'), '.', a:underline, 'g')
    call append('.', underline)
endfunction

nnoremap <leader>h1 :call <SID>Header('=')<CR>
nnoremap <leader>h2 :call <SID>Header('-')<CR>
