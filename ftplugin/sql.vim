
let g:sql_ft_file = expand("<sfile>")
function! SqlNewWord(word)
    let lines = readfile(g:sql_ft_file)
    let new = printf('ia %s %s', a:word, toupper(a:word))
    call insert(lines, new, len(lines))
    call writefile(lines, g:sql_ft_file)
endfunction
comm! -nargs=1 Sql call SqlNewWord(<f-args>)
nnoremap <leader>gn :exe "Sql " . expand("<cword>")<CR>

ia add ADD
ia alter ALTER
ia as AS
ia create CREATE
ia delete DELETE
ia drop DROP
ia exists EXISTS
ia from FROM
ia identity IDENTITY
ia if IF
ia insert INSERT
ia into INTO
ia key KEY
ia not NOT
ia null NULL
ia primary PRIMARY
ia select SELECT
ia set SET
ia table TABLE
ia table TABLE
ia update UPDATE
ia values VALUES
ia view VIEW
ia where WHERE
