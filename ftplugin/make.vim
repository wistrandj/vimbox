" NOTE: This is also defined in ftplugin/c.vim
nnoremap <leader>mc :silent make<CR>:redraw!<CR>
nnoremap <leader>mC :silent make clean<CR>:redraw!<CR>

function! s:PKG(input, lib)
    let out = system('pkg-config --' . a:input . ' ' . a:lib)
    if v:shell_error != 0
        echoerr "Couldn't find library " . a:lib
        return ''
    endif

    return out
endfunction

function! s:PKGAppend(arg)
    let line = getline('.')
    let out = ''

    if line =~ 'FLAGS'
        let out = s:PKG('cflags', a:arg)
    elseif line =~ 'LIBS'
        let out = s:PKG('libs', a:arg)
    endif

    if !empty(out)
         call setline(line('.'), line . ' ' . out)
    endif
endfunction

command! -nargs=1 PKG call <SID>PKGAppend(<f-args>)
