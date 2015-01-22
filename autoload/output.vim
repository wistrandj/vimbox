
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
" * output#switch_to() changes the window to output window
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

" ------------------------------------------------------------------------------
" public interface

fun! output#toggle()
    if s:window_nr() == -1
        cal output#open()
    else
        cal output#close()
    endif
endfun

fun! output#open()
    if s:window_nr() != -1
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

fun! output#close()
    let nr = s:window_nr()
    if nr != -1
        exe nr . " wincmd w"
        wincmd c
        wincmd p
    end
endfun

fun! output#text(out)
    call output#switch_to()
    exe "normal! ggdGi" . a:out
    wincmd p
endfun

fun! output#append(out)
    call output#switch_to()
    call append(line('$'), a:out)
    wincmd p
endfun

fun! output#switch_to()
    call output#open()
    exe s:window_nr() . " wincmd w"
endfun



" ------------------------------------------------------------------------------
" Private functions

fun! s:set_default_value(variable, value)
    let rval = a:value
    if (type(a:value) == 1) " String
        let rval = "\"" . a:value . "\""
    endif

    if !exists(a:variable)
        exe "let " . a:variable . " = " . rval
    end
endfun

call s:set_default_value("g:output_window_size", 7)
call s:set_default_value("g:output_window_name", "__output__")

fun! s:window_nr()
    return bufwinnr(g:output_window_name)
endfun

