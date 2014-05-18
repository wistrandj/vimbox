" TODO:
" - use Asyncs:make if it's available

command! -nargs=* InitSource call s:cmd_init_source_file(<f-args>)

autocmd BufWritePre <buffer> :%s/\s\+$//e

nnoremap <buffer> <Leader>r :call <SID>run_echo()<CR>
nnoremap <buffer> <Leader>mar :call <SID>run_async()<CR>
nnoremap <buffer> <Leader>mr :call <SID>run_output()<CR>
nnoremap <buffer> <leader>mc :call <SID>compile()<CR>
nnoremap <buffer> <leader>mC :call <SID>make("clean")<CR>

" Open quickfix window on compile errors
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

autocmd TabLeave * cclose


" Abbreviations for obnoxious words
abbrev nlch '\0'

abbrev u1 uint16_t
abbrev u3 uint32_t
abbrev u6 uint64_t

abbrev i1 int16_t
abbrev i3 int32_t
abbrev i6 int64_t


" -----------------------------------------------------------------------------
" s:compile and s:run_ C/C++ sources
" NOTE: These funs depends on MyOutput (output.vim)

fun! s:make(...)
    let arg = ""
    if a:0 > 1
        let arg = a:1
    end

    if filereadable("makefile") || filereadable("s:makefile")
        exe "make " . arg
        return 1
    end

    return 0
endfun

fun! s:compile()
    if s:make()
        return 1
    else
        exe ":!clear"
        let cmd = "gcc " . expand("%") . " -Wall -o a.out"
        echo system(cmd)
    endif

    return 1

endfun

fun! s:run_echo()
    try
        echo s:run_C()
    endtry
endfun

fun! s:run_output()
    try
        let out = s:run_C()
        call OutputText(out)
    endtry
endfun

fun! s:run_async()
    let file = s:find_executable(1)
    if executable(file)
        call system("./" . file . " &")
    endif
endfun


" -----------------------------------------------------------------------------
" Private

fun! s:run_C()
    let file = s:find_executable(1)
    let out = ""
    if executable(file)
        return system("./" . file)
    endif

    echoerr "ftplugin/c.vim|runC(): Couldn't find executable"
    throw "ExecutableNotFound"
endfun

fun! s:find_executable(trycompile)
    if exists("g:exefile") && executable("./" . g:exefile)
        return "./" . g:exefile
    elseif executable("./a.out")
        return "./a.out"
    elseif a:trycompile && s:compile()
        return s:find_executable(0)
    else
        return s:ask_executable()
    endif

endfun

fun! s:ask_executable()
    let g:exefile = input("Enter the name of the executable file: ")
    if !executable(g:exefile)
        echo g:exefile . " is not an executable file"
        return ""
    endif
    return g:exefile
endfun

fun! s:cmd_init_source_file(...)
    echo "cmd_init_source_file input: " . string(a:000)
    let name = ''
    let split = 1

    for input in a:000
        if input == '-q' || input == "--nosplit"
            let split = 0
        else
            let name = input
        endif
    endfor

    if empty(name)
        echoerr "No file name given"
        return
    endif

    let hfile = s:init_source_file(name)
    let cfile = substitute(hfile, '.h$', '.c', '')

    if l:split
        silent! exe "edit " . cfile
        silent! exe "vsplit " . hfile
    endif
endfun

fun! s:init_source_file(name)
    let src = isdirectory('src') ? 'src/' : ''
    let cfile = src . a:name . ".c"
    let hfile = src . a:name . ".h"
    let macro = toupper(a:name . "_H")

    if (s:source_file_exists_and_not_empty(cfile))
        echoerr cfile . " already exists"
        return
    elseif (s:source_file_exists_and_not_empty(hfile))
        echoerr hfile . " already exists"
        return
    endif

    let hlines = ['#ifndef ' . macro, '#define ' . macro,
    \             '', '', '', '#endif // ' . macro]
    let clines = ['#include "' . substitute(hfile, '^src/', '', ''), '', '']

    call writefile(hlines, hfile)
    call writefile(clines, cfile)
    return hfile
endfun

fun! s:source_file_exists_and_not_empty(file)
    if !filereadable(a:file)
        return 0
    else
        return !empty(readfile(a:file))
    endif
endfun
