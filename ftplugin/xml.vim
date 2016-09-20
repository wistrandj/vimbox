function! GetTagBeforeCursor()
    let col = col('.')
    let line = getline('.')[:col-1]
    return substitute(line, '.*\ze<', '', 'g')
endfunction

function! RemoveArguments(tag)
    return substitute(a:tag, ' *\ze>', '', '')
endfunction

function! CloseTag(tag)
    return substitute(a:tag, '<', '</', '')
endfunction

function! AddEndingTag()
    return CloseTag(RemoveArguments(GetTagBeforeCursor()))
endfunction

function! AddEndingTag()
    let s = CloseTag(RemoveArguments(GetTagBeforeCursor()))
    let ln = len(s)
    return s . repeat("\<LEFT>", ln)
endfunction

function! AddEndingTagNewline()
    return "\r" . CloseTag(RemoveArguments(GetTagBeforeCursor()))
endfunction

inoremap <expr> <C-g><space> AddEndingTag()
inoremap <expr> <C-g><CR> AddEndingTagNewline()
