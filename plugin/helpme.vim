
command! ShowIndentationOptions call <SID>ShowIndentationOptions()
command! ShowRuntimepath call <SID>ShowRuntimepath()

" NOTE(2023-09-20): Useful? Previously in .vimrc.local. Needs stupid autocmd
" hack because info#Register is not available by the time vim reads this
" script.
" au VimEnter * call info#Register('indent', function('ShowIndentationOptions'))
" au VimEnter * call info#Register('rtp', function('ShowRuntimepath'))

function! s:ShowIndentationOptions()
    echo printf('autoindent:  %s', &autoindent)
    echo printf('smartindent: %s', &smartindent)
    echo printf('cindent:     %s', &cindent)
    echo printf('  cindent: %s', &cindent)
    echo printf('  cinkeys: %s', &cinkeys)
    echo printf('  cinoptions: %s', &cinoptions)
    echo printf('  cinwords: %s', &cinwords)
    echo printf('indentexpr:  %s', &indentexpr)
endfunction

function! s:ShowRuntimepath()
    for plugin in split(&rtp, ',')
        echo plugin
    endfor
endfunction

