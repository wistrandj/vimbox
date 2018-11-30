inoremap <expr> <buffer> <CR> <SID>InsertTagAfterEnter()
inoremap <expr> > <SID>DuplicateTag()
" inoremap <expr> :g <SID>SkipTag()

inoremap <expr> <leader>b <SID>Bold('b')
inoremap <expr> <leader>i <SID>Bold('i')

let g:VIMBOX_UNCLOSED_ELEMENTS = ['link']

function s:SkipTag()
    return "\<ESC>f>a"
endfunction

function s:Bold(style)
    return printf('<%s></%s>%s', a:style, a:style, repeat("\<LEFT>", len(a:style) + 3))
endfunction

function s:DuplicateTag()
    let NO_MATCH = '>'
    let line = getline('.')[:col('.') - 2]
    let last_tag = substitute(line, '.*<\(\w\+\)\( [^>]*\)\?', '\1', '')

    if last_tag !~ '^\w\+$' || index(g:VIMBOX_UNCLOSED_ELEMENTS, last_tag) >= 0
        return NO_MATCH
    endif

    let next_closed_tag = search(printf('</%s>', last_tag), 'nW')
    let next_opened_tag = search(printf('<%s', last_tag), 'nW')
    let is_closed = (next_closed_tag > 0)
    let is_opened_before = (next_opened_tag > 0 && (next_closed_tag > next_opened_tag))
    if is_closed && !is_opened_before
        return NO_MATCH
    endif

    return printf('></%s>%s', last_tag, repeat("\<LEFT>", len(last_tag) + 3))
endfunction

function! s:InsertTagAfterEnter()
    let NO_MATCH = "\<CR>"
    let line = getline('.')
    let col = col('.')
    let [pre, rest] = [line[:col-2], line[col-1:]]
    echom pre
    echom rest

    if pre[-1:] != '>'
        return NO_MATCH
    endif

    let last_tag = substitute(pre, '.*<\(\w\+\)\( [^>]*\)\?>$', '\1', '')
    if last_tag !~ '^\w\+$' || index(g:VIMBOX_UNCLOSED_ELEMENTS, last_tag) >= 0
        return NO_MATCH
    endif

    if rest !~ printf("</%s>.*", last_tag)
        return NO_MATCH
    endif

    return printf("\<CR>\<CR>\<UP>")
endfunction
