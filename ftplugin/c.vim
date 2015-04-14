" FIXME: something in the last commit made .c-files to hang on start of the
" Vim
"  * WTF if there is a `finish` command in this file (anywhere), it'll not
"    hang

if exists('g:loaded_ftplugin_c')
    finish
endif
let g:loaded_ftplugin_c = 1

let &l:colorcolumn=81
hi ColorColumn ctermbg=0


" Open quickfix window on compile errors
" autocmd QuickFixCmdPost [^l]* nested cwindow
" autocmd QuickFixCmdPost    l* nested lwindow
autocmd TabLeave * cclose
autocmd BufWritePre <buffer> :%s/\s\+$//e

" === Commands and mappings ===================================================

    " COMMAND: Initfiles
    " Creates header and source file with proper contents
com! -nargs=* Initfiles call s:cmd_init_files(<f-args>)
    "
    " COMMAND: MoveHeader
    " Create a header file with
com! -range MoveHeader
    \ call s:cmd_move_selected_lines_to_header(<line1>, <line2>)

    " Split/vertical split the alternate header/source file
nn <C-w>a :call <SID>cmd_split_alternate_file('v')<CR>
nn <C-w>A :call <SID>cmd_split_alternate_file('')<CR>

    " Compile/make/run the program
nn <Leader>r :call <SID>run_echo()<CR>
nn <Leader>mar :call <SID>run_async()<CR>
nn <Leader>mr :call <SID>run_output()<CR>
nn <Leader>R :make<CR>:call <SID>run_output()<CR>
    " NOTE: This is also defined in ftplugin/make.vim
nn <leader>mc :call <SID>compile()<CR>
nn <leader>mC :call <SID>make("clean")<CR>
nn <leader>mt :call <SID>make("tags")<CR>
nn <leader>mi :call <SID>make("install")<CR>

    " These are not set as <buffer> because the error may be in makefile
nn <leader>ef :cr<CR>:cn<CR>
nn <leader>en :cn<CR>
nn <leader>ep :cp<CR>

    " Insert a colon after next parenthesis
ino <expr> ; <SID>insert_semicolon()

" === Abbreviations for obnoxious words =======================================
ia nlch '\0'
ia nl NULL
ia ddb debug
ia nst const

ia u8 uint8_t
ia u1 uint16_t
ia u3 uint32_t
ia u6 uint64_t
ia i1 int16_t
ia i3 int32_t
ia i6 int64_t

ia cn const
ia un unsigned
ia en enum
ia st struct
ia sta static
ia bk break;

ia cchar const char

" Initialize registers
exe 'let @l="$s\<CR>{\<CR>\<ESC>ddko"'

" === Private functions =======================================================
" s:compile and s:run_ C/C++ sources
" NOTE: These funs depends on MyOutput (output.vim)

    " Run make possibly with a sigle argument
function! s:make(...)
    let arg = ""
    if a:0 > 0
        let arg = a:1
    endif

    if filereadable("makefile") || filereadable("Makefile")
        exe "silent make " . arg
        redraw! " CLI Vim's UI breaks with 'silent' command for some reason
        return 1
    endif

    return 0
endfunction

    " Uses makefile to compile sources or just gcc -Wall <file> if it doesn't
    " exists
function! s:compile()
    if s:make()
        return 1
    else
        exe 'set makeprg=gcc\ -Wall\ ' . expand("%")
        make
    endif

    return 1
endfunction

function! s:run_echo()
    try
        let out = s:run_C()
        if !empty(out)
            echo out
        endif
    endtry
endfunction

function! s:run_output()
    try
        let out = s:run_C()
        if !empty(out)
            call output#text(out)
        endif
    endtry
endfunction

function! s:run_async()
    let file = s:find_executable(1)
    if executable(file)
        call system("./" . file . " &")
    endif
endfunction

" === Private =================================================================

function! s:insert_semicolon()
    let line = getline('.')
    let ch = strpart(getline('.'), col('.') - 1)
    if line =~ "\s*for\>" || ch != ')'
        return ";"
    endif

    return "\<right>;\<esc>"
endfunction

function! s:run_C()
    let file = s:find_executable(1)
    let out = ""
    if executable(file)
        return system("./" . file)
    endif

    echoerr "ftplugin/c.vim|run_C(): Couldn't find executable"
    throw "ExecutableNotFound"
endfunction

function! s:find_executable(trycompile)
    if exists("g:exefile") && executable("./" . g:exefile)
        return "./" . g:exefile
    elseif executable("./a.out")
        return "./a.out"
    elseif a:trycompile && s:compile()
        return s:find_executable(0)
    else
        return s:ask_executable()
    endif

endfunction

function! s:ask_executable()
    let g:exefile = input("Enter the name of the executable file: ")
    if !executable(g:exefile)
        echo g:exefile . " is not an executable file"
        return ""
    endif
    return g:exefile
endfunction

" === Functions for commands ==================================================

function! s:cmd_split_alternate_file(splitmode)
    " PARAM: splitmode may be either '' or 'v' for horizontal/vertical split
    let altfile = langc#alternate_file()

    if filereadable(altfile)
        silent! exe a:splitmode . "split " . altfile
    else
        echoerr "Couldn't find alternate file"
    endif
endfunction

function! s:aux_fix_selected_lines_before_moving(lines)
    let lastline = a:lines[ len(a:lines) - 1 ]
    if (lastline[-2:] == ' {')
        let lastline = lastline[:-2] . ';'
    else
        let lastline = lastline . ';'
    endif

    let a:lines[ len(a:lines) - 1 ] = lastline
    call add(a:lines, '')
endfunction

function! s:cmd_move_selected_lines_to_header(line1, line2)
    let lines = []
    for i in range(a:line1, a:line2)
        call add(lines, getline(i))
    endfor

    call s:aux_fix_selected_lines_before_moving(lines)

    " Change to the header
    let header = langc#alternate_file()
    if (header[-2:] != '.h')
        echoerr 'File ' . header . " is not header or it doesn't exists"
    endif

    exe "edit " . header
    normal! G
    let line = search('^$', 'b')
    call append(line, lines)

    exe "edit " . langc#alternate_file()
endfunction

function! s:cmd_init_files(...)
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

    call langc#init_header_source(name)

    " Reload CtrlP's cache if it's loaded
    if exists("g:loaded_ctrlp") | CtrlPClearCache | endif
endfunction



    " NOTE: These functions are for including new headers
function! s:skip_headers(pattern)
    " TODO Skip lines that match a:pattern
    return line('.')
endfunction
function! s:find_line_for_header()
    let pattern = "#include \".*\""
    let lnum = search(pattern)
    if lnum == 0
        return 1
    endif
    return s:skip_headers("#include <.*>")
endfunction
function! s:find_line_for_sys_header()
    let pattern="#include <.*>"
    let lnum = search(pattern)
    if lnum != 0
        return lnum + 1
    endif

    " Add system headers after regular headers
    let lnum = search("#include \".*\"")
    if lnum == 0
        return 1
    endif
    return s:skip_headers(pattern)
endfunction
function! s:add_header_to_line(headerline, lnum)
    if (0 != search(a:headerline, 'n'))
        echo a:headerline . " is already included!"
        return
    endif
    echo "Adding after line num " . a:lnum
    call append(a:lnum, a:headerline)
endfunction
function! s:include_header(name, sys_header)
    let pos = getcurpos()
    call cursor(1, 1)
    if a:sys_header
        let lnum = s:find_line_for_sys_header()
        let l = '<'
        let r = '>'
    else
        let lnum = s:find_line_for_header()
        let l = '"'
        let r = '"'
    endif

    if lnum < 0 || line('$') < lnum
        let lnum = 1
    endif

    let line = '#include ' . l . a:name . r
    call s:add_header_to_line(line, lnum - 1)
    call cursor(pos)
endfunction
command! -nargs=1 -complete=file_in_path Header call <SID>include_header(<f-args>, 1)
command! -nargs=1 -complete=customlist,<SID>complete_include Include call <SID>include_header(<f-args>, 0)
nn <leader>in :call feedkeys(":Header ")<CR>
nn <leader>ii :call feedkeys(":Include ")<CR>
function! s:complete_include(arg, cmdline, curpos)
    let xs = split(glob('**/*.h*'))
    call filter(xs, 'v:val =~ a:arg')
    call map(xs, 'substitute(v:val, "^include\/", "", "")')
    return xs
endfunction

    " TODO: use abbreviations for inclusion of headers ^^^
function! s:abbrev_sys_header(header)
    " Use abbreviations for system headers
    let a = {'a': 'assert', 'm': 'math', 'io': 'stdio', 'str': 'string', 'lib': 'stdlib', 'uni': 'unistd'}
    if (has_key(a, a:header))
        return a[a:header]
    endif

    return a:header
endfunction
