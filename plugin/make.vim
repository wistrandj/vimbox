function! GetErrors()
    let s:copy_values = ['bufnr', 'lnum', 'col', 'text']
    let list = getqflist()
    let out = []

    for elem in list
        if !elem['valid']
            continue
        endif

        let new_elem = {}
        for val in s:copy_values
            let new_elem[val] = elem[val]
        endfor

        call insert(out, new_elem, len(out))
    endfor

    return out
endfunction

function! GetBufferErrors()
    let nr = bufnr('.')
    let all = GetErrors()
    let local = filter(all, 'v:val["bufnr"] == ' . nr)

    return local
endfunction

fun! ClearErrors()
    let b:error_positions = []
    call clearmatches()
endfun

fun! HighlightSingleError(err)
    let line = a:err['lnum']
    let col = a:err['col']
    let new = matchaddpos('ErrorMsg', [[line, col, 1]])

    echo "error: " . string(a:err)
    call insert(b:error_positions, new, len(b:error_positions))
endfun

fun! BeforeMake()
endfun

fun! AfterMake()
    echoerr "Running something"
    call feedkeys("<C-w>w") " change to previous window from QF win
    call HighlightBufferErrors()
endfun

au QuickfixCmdPre call BeforeMake()
au QuickfixCmdPost call AfterMake()

function! HighlightBufferErrors()
    call ClearErrors()
    let errors = GetBufferErrors()

    for err in errors
        call HighlightSingleError(err)
    endfor
endfunction

nn <F1> :call HighlightBufferErrors()<CR>
nn <F5> :source /home/jasu/.vim/bundle/mystuff/plugin/make.vim<CR>


