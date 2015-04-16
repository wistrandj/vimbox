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


" === Include headers with completion =========================================
"   TODO add abbreviations
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
    call append(a:lnum, a:headerline)
endfunction
function! s:include_header(name, sys_header)
    let pos = getpos('.')
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
    let pos[1] = pos[1] + 1
    call setpos('.', pos)
    echo ""
    echo line
endfunction
function! s:include_n_headers(sys_header, ...)
    for name in a:000
        call s:include_header(name, a:sys_header)
    endfor
endfunction
command! -nargs=+ -complete=customlist,<SID>std_completion Std call <SID>include_n_headers(1, <f-args>)
command! -nargs=+ -complete=file_in_path Header call <SID>include_n_headers(1, <f-args>)
command! -nargs=+ -complete=customlist,<SID>complete_include Include call <SID>include_n_headers(0, <f-args>)
nn <leader>is :call feedkeys(":Std ")<CR>
nn <leader>in :call feedkeys(":Header ")<CR>
nn <leader>ii :call feedkeys(":Include ")<CR>
function! s:complete_include(arg, cmdline, curpos)
    let xs = split(glob('**/*.h*'))
    call filter(xs, 'v:val =~ a:arg')
    call map(xs, 'substitute(v:val, "^include\/", "", "")')
    return xs
endfunction
function! s:std_completion(arg, cmdline, curpos)
    if &ft == 'c'
        return s:c_complete_list
    elseif &ft == 'cpp'
        return s:cpp_complete_list
    endif
endfunction

let s:c_complete_list =
\["ctype.h", "errno.h", "fenv.h", "float.h", "inttypes.h", "iso646.h",
\"limits.h", "locale.h", "math.h", "setjmp.h", "signal.h", "stdarg.h",
\"stdbool.h", "stddef.h", "stdint.h", "stdio.h", "stdlib.h", "string.h",
\"tgmath.h", "time.h", "uchar.h", "wchar.h", "wctype.h"]

let s:cpp_complete_list = s:c_complete_list +
\["cctype", "cerrno", "cfenv", "cfloat", "cinttypes", "ciso646", "climits",
\"clocale", "cmath", "csetjmp", "csignal", "cstdarg", "cstdbool", "cstddef",
\"cstdint", "cstdio", "cstdlib", "cstring", "ctgmath", "ctime", "cuchar",
\"cwchar", "cwctype", "array", "bitset", "deque", "forward_list", "list",
\"map", "queue", "set", "stack", "unordered_map", "unordered_set", "vector",
\"atomic", "condition_variable", "future", "mutex", "thread", "algorithm",
\"chrono", "codecvt", "complex", "exception", "functional", "initializer_list",
\"iterator", "limits", "locale", "memory", "new", "numeric", "random",
\"ratio", "regex", "stdexcept", "string", "system_error", "tuple", "typeindex",
\"typeinfo", "type_traits", "utility", "valarray"]

" === Show tags ===============================================================
" Show the tag under cursor
nn <leader>st :call <SID>show_tag()<CR>
function! s:find_nth_match(str, pat, n)
    let i = 0
    let s = -1
    while (i < a:n)
        let s = stridx(a:str, a:pat, s + 1)
        let i += 1
        if (s == -1)
            break
        endif
    endwhile
    return s
endfunction
function! s:split_three(str, n, m)
    let a = strpart(a:str, 0, a:n + 1)
    let b = strpart(a:str, a:n + 1, a:m - a:n - 1)
    let c = strpart(a:str, a:m)
    return [a, b, c]
endfunction
function! s:show_function_tag(tag, hlarg)
    echohl MoreMsg
    echo a:tag["name"]
    echohl Constant
    if (a:hlarg < 0)
        echon a:tag["signature"]
        echohl None
        return
    endif

    if (!has_key(a:tag, "signature"))
        " NOTE: This shouldn't happen
        echoerr "ERROR!"
        call s:show_struct_tag(a:tag)
        return
    endif

    let args = a:tag["signature"]
    let m = s:find_nth_match(args, ',', a:hlarg) + 1
    let n = stridx(args, ",", m)
    if (n == -1)
        let n = stridx(args, ")", m)
    endif
    let [a, b, c] = s:split_three(args, m, n)
    echon a | echohl Search | echon b | echohl Constant | echon c | echohl None
endfunction
function! s:show_struct_tag(tag)
    echo a:tag
endfunction
function! s:tag_info(word)
    let tags = taglist(a:word)
    if empty(tags)
        echo "No tags found"
        return {}
    endif
    return tags[0]
endfunction
function! s:show_tag()
    let word = expand("<cword>")
    let tag = s:tag_info(word)
    if empty(tag)
        return
    elseif has_key(tag, "signature")
        call s:show_function_tag(tag, -1)
    else
        call s:show_struct_tag(tag)
    end
endfunction

" Show the function tag and hilight current argument
nn <leader>sf :call <SID>show_function_tag_with_arguments()<CR>
function! s:poscmp(p1, p2)
    let [_,ln1, cl1,_,_] = a:p1
    let [_,ln2, cl2,_,_] = a:p2
    if (ln1 < ln2)
        return -1
    elseif (ln1 == ln2)
        return 1
    endif

    if (cl1 < cl2)
        return -1
    elseif (cl1 == cl2)
        return 1
    endif

    return 0
endfunction
function! s:find_parenthesis()
    let depth = 3
    let pos=getcurpos()
    let ln = pos[1]
    while (depth > 0)
        let depth -= 1
        let r = search('(', 'b', ln - 5)
        if (r == 0)
            break
        endif

        let left = getcurpos()
        norm! %
        let right = getcurpos()
        if (s:poscmp(right, pos) >= 0)
            return [left, right]
        endif
    endwhile

    return []
endfunction
function! s:nr_arg(left, pos)
    call setpos('.', a:pos)
    let commas = 0
    let pos = a:pos
    while (0 < s:poscmp(pos, a:left))
        let r = search(',', 'b')
        if (r == 0)
            break
        endif
        let pos = getcurpos()
        let commas += 1
    endwhile
    return commas - 1
endfunction
function! s:read_arg()
    let pos = getcurpos()
    let paren = s:find_parenthesis()
    if empty(paren)
        return []
    endif
    let [left, right] = paren
    let namepos = copy(left)
    let namepos[2] -= 1
    call setpos('.', namepos)
    let fnname = expand("<cword>")

    return [fnname, left, right, s:nr_arg(left, pos)]
endfunction
function! s:show_function_tag_with_arguments()
    let pos = getcurpos()
    let [func, left, right, nr] = s:read_arg()

    if (left == right)
        call s:show_tag()
        call setpos('.', pos)
        exe "norm! \<ESC>"
        echo "err!"
        return
    endif

    let tag = s:tag_info(func)
    if !empty(tag)
        call s:show_function_tag(tag, nr)
    endif
    call setpos('.', pos)
endfunction
