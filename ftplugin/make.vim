" NOTE: This is also defined in ftplugin/c.vim
nnoremap <leader>mc :silent make<CR>:redraw!<CR>
nnoremap <leader>mC :silent make clean<CR>:redraw!<CR>

function! s:PKG(input, lib)
    let out = system('pkg-config --' . a:input . ' ' . a:lib)
    if v:shell_error != 0
        echoerr "Couldn't find library " . a:lib
        return ''
    endif

    return join(split(out))
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
         echo printf("|%s|", line . ' ' . out)
    endif
endfunction

function! s:PKGCompletionFunc(arglead, cmdline, cursorpos)
    let last_arg=substitute(a:arglead, ".*\(\w*\)$", '\1', '')
    let pkgfiles = split(glob('/usr/lib/pkgconfig/*'))
    call filter(pkgfiles, 'v:val =~? "' . last_arg . '"')
    call map(pkgfiles, 'substitute(v:val, ".*\/\\(.*\\).pc", "\\1", "")')
    return pkgfiles
endfunction

command! -nargs=1 -complete=customlist,s:PKGCompletionFunc PKG call <SID>PKGAppend(<f-args>)
