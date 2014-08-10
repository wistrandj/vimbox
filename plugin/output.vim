
" PLUGIN:
" This plugin manages a window that can show information from other tools ie.
" other plugins and external programs.
"
" USE:
" The plugin has a simple interface.
" * OpenOutput() opens the window
" * CloseOutput() closes the window
" * OutputText(<string>) clears the output window and shows the <strings> in it
" * OutputAppend(<string>) appends <string> to the end of output buffer
" * SwitchToOutputWindow() changes the window to output window
"
" All functions but CloseOutput() opens the window if it's not already open.
"
" CAVEATS:
" There can be only one output buffer and therefore each tab shares the output
" buffer.

if exists("g:output_loaded")
    finish
end

let g:output_loaded = 1

nnoremap <leader>o :call InvOutput()<CR>


" ------------------------------------------------------------------------------
" public interface

fun! InvOutput()
    if s:OutputWindowNumber() == -1
        cal OpenOutput()
    else
        cal CloseOutput()
    endif
endfun

fun! OpenOutput()
    if s:OutputWindowNumber() != -1
        return
    end

    exe "topleft " . g:output_window_size . " new " . g:output_window_name
    set buftype=nofile
    set bufhidden=hide
    set noswapfile
    set noautoindent
    setlocal nosmartindent
    setlocal noautoindent
    wincmd p
endfun

fun! CloseOutput()
    let nr = s:OutputWindowNumber()
    if nr != -1
        exe nr . " wincmd w"
        wincmd c
        wincmd p
    end
endfun

fun! OutputText(out)
    call SwitchToOutputWindow()
    exe "normal! ggdGi" . a:out
    wincmd p
endfun

fun! OutputAppend(out)
    call SwitchToOutputWindow()
    call append(line('$'), a:out)
    wincmd p
endfun

fun! SwitchToOutputWindow()
    call OpenOutput()
    exe s:OutputWindowNumber() . " wincmd w"
endfun



" ------------------------------------------------------------------------------
" Private functions

fun! s:SetDefaultValue(variable, value)
    let rval = a:value
    if (type(a:value) == 1) " String
        let rval = "\"" . a:value . "\""
    endif

    if !exists(a:variable)
        exe "let " . a:variable . " = " . rval
    end
endfun

call s:SetDefaultValue("g:output_window_size", 7)
call s:SetDefaultValue("g:output_window_name", "__output__")

fun! s:OutputWindowNumber()
    return bufwinnr(g:output_window_name)
endfun

