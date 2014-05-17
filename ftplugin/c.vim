" TODO:
" - use AsyncMake if it's available

" Clang complete
let g:clang_complete_copen=1
let g:clang_hl_errors=1
set completeopt=menu,menuone    " Don't show the preview buffer
nnoremap <leader>cc :call g:ClangUpdateQuickFix()<CR>


" Remove trailing whitespace before saving
autocmd BufWritePre <buffer> :%s/\s\+$//e

" Binds
nnoremap <buffer> <Leader>r :call RunEcho()<CR>
nnoremap <buffer> <Leader>mar :call RunAsync()<CR>
nnoremap <buffer> <Leader>mr :call RunOutput()<CR>
nnoremap <buffer> <leader>mc :call Compile()<CR>
nnoremap <buffer> <leader>mC :call Make("clean")<CR>

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
" Compile and Run C/C++ sources
" NOTE: These funs depends on MyOutput (output.vim)

fun! Make(...)
    let arg = ""
    if a:0 > 1
        let arg = a:1
    end

    if filereadable("makefile") || filereadable("Makefile")
        exe "make " . arg
        return 1
    end

    return 0
endfun


fun! Compile()
    if Make()
        return 1
    else
        exe ":!clear"
        let cmd = "gcc " . expand("%") . " -Wall -o a.out"
        echo system(cmd)
    endif

    return 1

endfun

fun! RunEcho()
    try
        echo s:RunC()
    endtry
endfun

fun! RunOutput()
    try
        let out = s:RunC()
        call OutputText(out)
    endtry
endfun

fun! RunAsync()
    let file = s:FindExecutable(1)
    if executable(file)
        call system("./" . file . " &")
    endif
endfun


" -----------------------------------------------------------------------------
" Private

fun! s:RunC()
    let file = s:FindExecutable(1)
    let out = ""
    if executable(file)
        return system("./" . file)
    endif

    echoerr "ftplugin/c.vim|runC(): Couldn't find executable"
    throw "ExecutableNotFound"
endfun

fun! s:FindExecutable(trycompile)
    if exists("g:exefile") && executable("./" . g:exefile)
        return "./" . g:exefile
    elseif executable("./a.out")
        return "./a.out"
    elseif a:trycompile && Compile()
        return s:FindExecutable(0)
    else
        return s:AskExecutable()
    endif

endfun

fun! s:AskExecutable()
    let g:exefile = input("Enter the name of the executable file: ")
    if !executable(g:exefile)
        echo g:exefile . " is not an executable file"
        return ""
    endif
    return g:exefile
endfun
