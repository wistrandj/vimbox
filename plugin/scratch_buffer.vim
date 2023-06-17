let s:ScratchBufferNumber = -1
let s:ScratchBufferName = 'VIMBOX-TEMPORARY-BUFFER'

function s:SwitchToScratchBuffer()
    if s:ScratchBufferNumber == -1
        let s:ScratchBufferNumber = bufadd(s:ScratchBufferName)
        call s:ScratchMarkBuffer()
        " exec 'file ' . s:ScratchBufferName
        execute 'buffer ' . s:ScratchBufferNumber
    else
        if bufwinnr(s:ScratchBufferNumber) != -1
            execute bufwinnr(s:ScratchBufferNumber) . 'wincmd w'
        else
            execute 'buffer ' . s:ScratchBufferNumber
        endif
    endif
endfunction


function s:RGInScratchBuffer()
    call s:SwitchToScratchBuffer()

    if bufnr() == s:ScratchBufferNumber
        let line_count = line('$')
        exec 'normal ggdG'
        echo 'Removed ' . (line_count - 1) . ' lines from ' . s:ScratchBufferName
    endif

endfunction



" Copy-paste from https://github.com/vim-scripts/scratch.vim/blob/master/plugin/scratch.vim
function! s:ScratchMarkBuffer()
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal buflisted
endfunction


nnoremap <Plug>VimboxScratchBuffer_SwitchToScratchBuffer() :call <SID>SwitchToScratchBuffer()<CR>
nnoremap <Plug>VimboxScratchBuffer_RGInScratchBuffer() :call <SID>RGInScratchBuffer()<CR>:r!rg 

