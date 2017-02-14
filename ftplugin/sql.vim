
let g:sql_ft_file = expand("<sfile>")
function! SqlNewWord(word)
    let lines = readfile(g:sql_ft_file)
    let new = printf('ia %s %s', a:word, toupper(a:word))
    call insert(lines, new, len(lines))
    call writefile(lines, g:sql_ft_file)
endfunction
comm! -nargs=1 Sql call SqlNewWord(<f-args>)
nnoremap <leader>gn :exe "Sql " . expand("<cword>")<CR>

ia table TABLE
ia create CREATE
ia identity IDENTITY
ia key KEY
ia primary PRIMARY
ia null NULL
ia not NOT
ia delete DELETE
ia drop DROP
ia view VIEW
ia into INTO
ia insert INSERT
ia create CREATE
ia table TABLE
ia exists EXISTS
ia if IF
