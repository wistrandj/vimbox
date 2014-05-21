
" Open quickfix window on compile errors
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
autocmd TabLeave * cclose

" === Commands and mappings ===================================================

command! -nargs=* Initfiles call s:cmd_init_files(<f-args>)
command! -range -nargs=1 MoveHeader
    \ call s:cmd_move_selected_lines_to_header(<f-args>, <line1>, <line2>)

autocmd BufWritePre <buffer> :%s/\s\+$//e

nnoremap <C-w>a :call <SID>cmd_split_alternate_file()<CR>

nnoremap <buffer> <Leader>r :call <SID>run_echo()<CR>
nnoremap <buffer> <Leader>mar :call <SID>run_async()<CR>
nnoremap <buffer> <Leader>mr :call <SID>run_output()<CR>
nnoremap <buffer> <leader>mc :call <SID>compile()<CR>
nnoremap <buffer> <leader>mC :call <SID>make("clean")<CR>

" === Abbreviations for obnoxious words =======================================
abbrev nlch '\0'

abbrev u1 uint16_t
abbrev u3 uint32_t
abbrev u6 uint64_t

abbrev i1 int16_t
abbrev i3 int32_t
abbrev i6 int64_t

abbrev st struct

" === Private functions =======================================================
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


" === Private =================================================================

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

" === Functions for commands ==================================================

fun! s:cmd_split_alternate_file()
    let file = expand("%")
    let otherend = (match(file, '.h$') >= 0) ? '.c' : '.h'
    let other = substitute(file, '..$', otherend, '')

    if filereadable(other)
        silent! exe "vsplit " . other
    else
        echoerr "Couldn't find alternate file"
    endif
endfun

fun! s:cmd_move_selected_lines_to_header(name, line1, line2)
    let lines = []
    for i in range(a:line1, a:line2)
        call add(lines, getline(i))
    endfor

    if !langc#init_header_with(a:name, lines)
        return
    endif

    " Delete lines
    exe "normal! " . a:line1 . "GV" a:line2 . "GD"
endfun

fun! s:cmd_init_files(...)
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

    let hfile = langc#init_header_source(name)
    let cfile = substitute(hfile, '.h$', '.c', '')
endfun

