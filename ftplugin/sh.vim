ia <buffer> elog echo "$(date +%Y%m%d:%H%M)"<LEFT>

setlocal autoindent
au BufEnter *.sh call <SID>FillEmptyScript()
au BufWritePre *.sh call <SID>SaveAsExecutable_Pre()
au BufWritePost *.sh call <SID>SaveAsExecutable_Post()


if exists('s:loaded')
    finish
endif | let s:loaded = 1


function s:FillEmptyScript()
    if (byte2line(1) == -1)
        call append(0, ['#!/bin/bash', ''])
        normal! G
    endif
endfunction

function s:SaveAsExecutable_Pre()
    if !filereadable(expand('%'))
        let b:set_executable_bit = 1
    endif
endfunction

function s:SaveAsExecutable_Post()
    if exists('b:set_executable_bit')
        call system("chmod +x " . expand('%'))
        unlet b:set_executable_bit
    endif
endfunction
