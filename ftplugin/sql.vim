" if exists('g:vimbox_ft_loaded_sql')
" endif
" let g:vimbox_ft_loaded_sql = 1


" let s:reserved_words = ["add", "alter", "as", "create", "delete", "drop", "exists", "from", "identity", "if", "insert", "into", "key", "not", "null", "primary", "select", "set", "table", "table", "update", "values", "view", "where"]
let s:reserved_words = ["add", "alter"]

"
"_select * from add jotain and alter
"

function! Uppercase_reserved_words_in_selection()
    let pattern = join(s:reserved_words, '\|')
    let sl = line("'<")
    let sc = col("'<")
    let el = line("'>")
    let ec = col("'>")
    let mode 'v'
    " Single line case
    if mode == 'v' || mode == 'V' && sl == el
        let l = getline("'<")
        let s = ''
        let e = ''
        if (sc > 1)
            let s = l[:sc-2]
        endif
        let e = l[ec:]
        let mid = l[sc-1:ec-1]
        let mid = substitute(mid, pattern, '\U&', 'g')
        echo s . '|' . mid . '|' . e
    else
    " Multi line casse
    endif 0
        " TODO
    return
endfunction

let g:sql_ft_file = expand("<sfile>")
function! SqlNewWord(word)
    let lines = readfile(g:sql_ft_file)
    let new = printf('ia %s %s', a:word, toupper(a:word))
    call insert(lines, new, len(lines))
    call writefile(lines, g:sql_ft_file)
endfunction
comm! -nargs=1 Sql call SqlNewWord(<f-args>)
nnoremap <leader>gn :exe "Sql " . expand("<cword>")<CR>
