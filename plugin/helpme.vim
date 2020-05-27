" Show some indentation settings. Might be helpful when
"
function! ShowIndentationOptions()
    echo printf('autoindent:  %s', &autoindent)
    echo printf('smartindent: %s', &smartindent)
    echo printf('cindent:     %s', &cindent)
    echo printf('  cindent: %s', &cindent)
    echo printf('  cinkeys: %s', &cinkeys)
    echo printf('  cinoptions: %s', &cinoptions)
    echo printf('  cinwords: %s', &cinwords)
    echo printf('indentexpr:  %s', &indentexpr)
endfunction

function! ShowRuntimepath()
    for plugin in split(&rtp, ',')
        echo plugin
    endfor
endfunction
