inoremap <expr> <buffer> <CR> <SID>InsertTagAfterEnter()
inoremap <expr> > <SID>CloseAngleBracket()

let g:VIMBOX_UNCLOSED_ELEMENTS = ['link']

function s:CloseAngleBracket()
    let NO_MATCH = '>'
    let char = getline('.')[col('.') - 1]

    if char != '>'
        return NO_MATCH
    else
        return "\<RIGHT>"
    fi
endfunction

function! s:InsertTagAfterEnter()
    let NO_MATCH = "\<CR>"
    let line = getline('.')

    if line[-1:] != '>'
        return NO_MATCH
    endif

    let last_tag = substitute(line, '.*<\(\w\+\)\( [^>]*\)\?>$', '\1', '')
    if last_tag !~ '^\w\+$' || index(g:VIMBOX_UNCLOSED_ELEMENTS, last_tag) >= 0
        echom "Skipping"
        return NO_MATCH
    endif

    return printf("\<CR> \<BS>\<CR></%s>\<UP>", last_tag)
endfunction
