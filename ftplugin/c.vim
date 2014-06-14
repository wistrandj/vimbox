
let &l:colorcolumn=81
hi ColorColumn ctermbg=8

" Open quickfix window on compile errors
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
autocmd TabLeave * cclose

" === Commands and mappings ===================================================

    " COMMAND: Initfiles
    " Creates header and source file with proper contents
command! -nargs=* Initfiles call s:cmd_init_files(<f-args>)
    "
    " COMMAND: MoveHeader
    " Create a header file with 
command! -range -nargs=1 MoveHeader
    \ call s:cmd_move_selected_lines_to_header(<f-args>, <line1>, <line2>)

autocmd BufWritePre <buffer> :%s/\s\+$//e

    " Split/vertical split the alternate header/source file
nnoremap <C-w>a :call <SID>cmd_split_alternate_file('v')<CR>
nnoremap <C-w>A :call <SID>cmd_split_alternate_file('')<CR>

    " Compile/make/run the program
nnoremap <buffer> <Leader>r :call <SID>run_echo()<CR>
nnoremap <buffer> <Leader>mar :call <SID>run_async()<CR>
nnoremap <buffer> <Leader>mr :call <SID>run_output()<CR>
nnoremap <buffer> <Leader>R :make<CR>:call <SID>run_output()<CR>
nnoremap <buffer> <leader>mc :call <SID>compile()<CR>
nnoremap <buffer> <leader>mC :call <SID>make("clean")<CR>
nnoremap <buffer> <leader>mt :call <SID>make("tags")<CR>

    " These are not set as <buffer> because the error may be in makefile
nnoremap <leader>ef :cr<CR>:cn<CR>
nnoremap <leader>en :cn<CR>
nnoremap <leader>ep :cp<CR>

" === Abbreviations for obnoxious words =======================================
ia nlch '\0'
ia nl NULL
ia ddb debug
ia nst const

abbrev u8 uint8_t
abbrev u1 uint16_t
abbrev u3 uint32_t
abbrev u6 uint64_t
abbrev i1 int16_t
abbrev i3 int32_t
abbrev i6 int64_t

abbrev en enum
abbrev st struct
abbrev sta static


" === Private functions =======================================================
" s:compile and s:run_ C/C++ sources
" NOTE: These funs depends on MyOutput (output.vim)

    " Run make possibly with a sigle argument
fun! s:make(...)
    let arg = ""
    if a:0 > 0
        let arg = a:1
    end

    if filereadable("makefile") || filereadable("Makefile"))
        exe "make " . arg
        return 1
    end

    return 0
endfun

    " Uses makefile to compile sources or just gcc -Wall <file> if it doesn't
    " exists
fun! s:compile()
    if s:make()
        return 1
    else
        exe 'set makeprg=gcc\ -Wall\ ' . expand("%")
        make
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

fun! s:cmd_split_alternate_file(splitmode)
    " PARAM: splitmode may be either '' or 'v' for horizontal/vertical split
    let file = expand("%")
    let otherend = (match(file, '.h$') >= 0) ? '.c' : '.h'
    let other = substitute(file, '..$', otherend, '')

    if filereadable(other)
        silent! exe a:splitmode . "split " . other
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

