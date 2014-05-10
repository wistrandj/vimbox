

" -----------------------------------------------------------------------------
" Projects and Git

if filereadable("project.vim")
    source project.vim
endif

nnoremap <leader>gs :echo system("git status")<CR>
nnoremap <leader>gc :call GitCommit()<CR>

function! GitCommit()
    let msg = input("Commit message: ")
    :echo system("git commit -am \"" . msg . "\"")
endfunction

" -----------------------------------------------------------------------------
" Runfile

command! Run call runfile#Run()
command! Runout call runfile#RunFileToOutPut()

" -----------------------------------------------------------------------------
" Matching Chars

inoremap <expr> ( matchingChars#InsertLeftParenthesis("(")
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<esc>ko

inoremap <expr> ) matchingChars#InsertRightParenthesis(")")
inoremap <expr> ] matchingChars#InsertRightParenthesis("]")
inoremap <expr> } matchingChars#InsertRightParenthesis("}")
inoremap <expr> " matchingChars#InsertQuote("\"")

imap <expr> <BS> matchingChars#RemoveSomething()

" -----------------------------------------------------------------------------
" Open well-known windows

nmap <c-w>o <nop>
nnoremap <c-w>oo :call OpenOutput()<cr>

" -----------------------------------------------------------------------------
" Insert Something

nnoremap <expr> <leader>hh <SID>ToggleHilightSearch()
function! s:ToggleHilightSearch()
    " <leader>hh
    let nextstate = (&hls == 0) ? "on" : "off"
    set invhls
    echo "HLS " . nextstate
endfunction

nnoremap <leader>im :call <SID>DropRestBelow()<CR>ka
nnoremap <leader>cm :call <SID>DropRestBelow()<CR>gccka
function! s:DropRestBelow()
    let col = col('.')
    exe "normal! i\<CR>\<ESC>0d^" . col . "i \<ESC>x"
endfunction

nnoremap <leader>mi :call <SID>InsertBelow()<CR>
function! s:InsertBelow()
    " <leader>mi
    let column = col('.') - 1
    exe "normal! o\<ESC>" . column . "i "
    startinsert!
endfunction

" -----------------------------------------------------------------------------
" Misc

command! Lorem execute "r!cat /home/jasu/doc/data/templates/lorem"

function! QuickfixWrite()
    if &buftype != "quickfix"
        return
    endif

    let changelists = {}
    for i in range(1, line('$'))
        call ReadQuickfixLine(changelists, line(i))
    endfor

    call ApplyQuickfixChanges(changelists)
endfunction

function! ApplyQuickfixChanges(changelists)
    for file in keys(a:changelists)
        let lines = readfile(file)

        for [linenr, newline] in a:changelists[file]
            let lines[linenr] = newline
        endfor

        call writefile(lines, file)
    endfor
endfunction

function! ReadQuickfixLine(changelists, line)
    let [file, linenr, newline] = split(line, '|')
    let newline = newline[1:]

    if !has_key(a:changelists, file)
        let a:changelists[l:file] = []
    endif

    call add(a:changelists[l:file], [linenr, newline])
endfunction
