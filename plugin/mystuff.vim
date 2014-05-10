
" -----------------------------------------------------------------------------
" Copy 5 paragraphs of Lorem ipsum
command! Lorem execute "r!cat /home/jasu/doc/data/templates/lorem"

if filereadable("project.vim")
    source project.vim
endif

" -----------------------------------------------------------------------------
" GitCommit()
function! GitCommit()
    let msg = input("Commit message: ")
    :echo system("git commit -am \"" . msg . "\"")
endfunction

nnoremap <leader>gs :echo system("git status")<CR>
nnoremap <leader>gc :call GitCommit()<CR>


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

nnoremap <leader>mi :call <SID>InsertBelow()<CR>
nnoremap <leader>im :call <SID>DropRestBelow()<CR>ka
nmap <leader>cm :call <SID>DropRestBelow()<CR>gccka

fun! s:DropRestBelow()
    let col = col('.')
    exe "normal! i\<CR>\<ESC>0d^" . col . "i \<ESC>x"
endfun

fun! s:InsertBelow()
    " <leader>mi
    let column = col('.') - 1
    exe "normal! o\<ESC>" . column . "i "
    startinsert!
endfun

fun! s:ToggleHilightSearch()
    " <leader>hh
    let nextstate = (&hls == 0) ? "on" : "off"
    set invhls
    echo "HLS " . nextstate
endfun

