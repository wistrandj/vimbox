inoremap <buffer> " "
nnoremap <buffer> K :exe "help " . expand("<cword>")<CR>
nnoremap <buffer> gl :call <SID>goto_nth_line_of_function(v:count)<CR>

command! Path call append(line('.'), '"' . expand('%:p:h') . '"') | normal! J

if exists('s:loaded')
    finish
endif | let s:loaded = 1

function s:goto_nth_line_of_function(n)
    exe printf("normal! ?^function\<CR>%dj", a:n)
endfunction
