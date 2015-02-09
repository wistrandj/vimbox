inoremap <buffer> " "
nnoremap <buffer> K :exe "help " . expand("<cword>")<CR>

command! Path call append(line('.'), '"' . expand('%:p:h') . '"') | normal! J
