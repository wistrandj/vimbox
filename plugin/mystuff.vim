" SECTION Mappings
" ==== Projects and Git =======================================================

if filereadable("project.vim")
    source project.vim
endif

nnoremap <leader>gs :call git#status()<CR>
nnoremap <leader>gc :call git#commit()<CR>

" === Insert Something ========================================================

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
    let column = col('.') = 1
    exe "normal! o\<ESC>" . column . "i "
    startinsert!
endfunction

" === Scroll with <C-y> and <C-e> " ===========================================

let s:scroll_max = 10
let s:scroll_min = 3

nnoremap <c-y> :call <SID>scroll_block(-1)<CR>
nnoremap <c-e> :call <SID>scroll_block(1)<CR>
function! s:find_blank_line(linenr, lines, by, times)
    let nr = a:linenr
    let i = 0

    while (i < a:times && 1 < nr && nr < a:lines)
        if getline(nr) =~ "^\s*$"
            return nr
        endif
        let nr += a:by
        let i += 1
    endwhile
    return nr
endfunction
function! s:scroll_block(dir)
    " NOTE: quotes or ' with \<C-y> ?
    let winedge = line('w0')
    let key = "\<C-y>"
    if (a:dir > 0)
        let key = "\<C-e>"
        let winedge = line('w$')
    endif

    let blank = s:find_blank_line(winedge + a:dir, line('$'), a:dir, s:scroll_max)
    let diff = abs(blank - winedge)
    let diff = (diff < s:scroll_min) ? s:scroll_min : diff
    let diff = (diff > s:scroll_max) ? s:scroll_max : diff

    exe "normal! " . diff . key
endfunction

" ENDSECTION
" SECTION Commands

command! Sep call <SID>MakeCommentSeparator()
function! s:MakeCommentSeparator()
    let comment = substitute(getline('.'), '^\([^ ]*\).*', '\1', '')
    let txt = substitute(getline('.'), '^[^ ]* *\(.*\) *$', '\1', '')
    let len = len(comment) + len(txt) + 1
    let line = comment . ' === ' . txt . ' ' . repeat('=', 79 - len - 5)
    call setline('.', line)
endfunction

" ENDSECTION
" SECTION Mappings for autoload/
" === Misc ====================================================================

command! Lorem execute "r!cat /home/jasu/doc/data/templates/lorem"
" === Runfile =================================================================

command! Run call runfile#Run()
command! Runout call runfile#RunFileToOutput()

" === Matching Chars ==========================================================

inoremap <expr> ( matchingChars#InsertLeftParenthesis("(")
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<esc>ko

inoremap <expr> ) matchingChars#InsertRightParenthesis(")")
inoremap <expr> ] matchingChars#InsertRightParenthesis("]")
inoremap <expr> } matchingChars#InsertRightParenthesis("}")
inoremap <expr> " matchingChars#InsertQuote("\"")

imap <expr> <BS> matchingChars#RemoveSomething()

" === Open well-known windows =================================================

nnoremap <c-w>oo :call OpenOutput()<cr>

" === Refactor ================================================================


" FIXME:
nnoremap <leader>ss :exe "normal! :%s/" . expand("<cword>") . "\/\<ESC>q:kA"
command! -nargs=? Rename :call <SID>mygrep('*', <f-args>)
command! RenameA :call ()
function! s:mygrep(filepattern, ...)
    if a:0 == 0
        let word = expand("<cword>")
    else
        let word = a:1
    endif
    call refactor#grep(word, a:filepattern)
endfunction

" ENDSECTION

