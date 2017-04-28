if exists('g:vimbox_ft_sh_loaded')
    finish
endif
let g:vimbox_ft_sh_loaded = 1

ia elog echo "$(date +%Y%m%d:%H%M)"<LEFT>


au BufEnter *.sh call <SID>FillEmptyScript()
au BufWritePre *.sh call <SID>SaveAsExecutable_Pre()
au BufWritePost *.sh call <SID>SaveAsExecutable_Post()



function s:FillEmptyScript()
    if (byte2line(1) == -1)
        call append(0, ['#!/bin/bash', ''])
        normal! G
    endif
endfunction

function s:SaveAsExecutable_Pre()
    echom "PRE"
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
