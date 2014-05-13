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
" ENDSECTION
" SECTION Mappings for autoload/
" === Misc ====================================================================

command! Lorem execute "r!cat /home/jasu/doc/data/templates/lorem"
" === Runfile =================================================================

command! Run call runfile#Run()
command! Runout call runfile#RunFileToOutPut()

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

nmap <c-w>o <nop>
nnoremap <c-w>oo :call OpenOutput()<cr>

" === Refactor ================================================================

command! RenameA :call refactor#ApplyQuickfixChanges()<CR>
command! -nargs=1 Rename :call <SID>rename(<f-args>)
function! s:rename(word)
    exe "vimgrep /" . a:word . "/j **"
    copen
    set modifiable
endfunction

" ENDSECTION
