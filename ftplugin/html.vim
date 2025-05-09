setlocal indentexpr=

command -nargs=1 Insert :call HTML__Insert(<f-args>)
inoremap <expr> <c-l> HTML__CloseLastTag()

function HTML__CloseLastTag()
    let string = getline('.')
    let tag = substitute(string, '.*\ze<', '', '')

    let res1 = substitute(tag, '<', '</', '')
    let res2 = substitute(res1, '>.*', '>', '')
    return res2
endfunction

function HTML__Insert(argument)
    let stack = split(a:argument, '/')
    let lines = []
    let trailer = []
    for item in stack
        call add(lines, '<' . item . '>')
        call add(trailer, '</' . item . '>')
    endfor

    for item in reverse(trailer)
        call add(lines, item)
    endfor

    let lnum = getpos('.')[1]
    let plus = 0

    for item in lines
        call append(lnum + plus, item)
        let plus = plus + 1
    endfor

endfunction
