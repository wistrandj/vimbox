
let g:sql_ft_file = expand("<sfile>")
function! SqlNewWord(word)
    let lines = readfile(g:sql_ft_file)
    let new = printf('ia %s %s', a:word, toupper(a:word))
    call insert(lines, new, len(lines))
    call writefile(lines, g:sql_ft_file)
endfunction
comm! -nargs=1 Sql call SqlNewWord(<f-args>)
nnoremap <leader>gn :exe "Sql " . expand("<cword>")<CR>

