nnoremap <leader>R set ft=tab<CR>

fun! s:next_section()
    call search('@', 'W')
    exe "normal! z\<CR>"
endfun

nnoremap <space> :call <SID>next_section()<CR>
nnoremap <CR> gg

let @l = "$\<c-v>5jA|\<esc>"

set nocursorline
