" Copy 5 paragraphs of Lorem ipsum
command! Lorem execute "r!cat /home/jasu/doc/data/templates/lorem"

if filereadable("project.vim")
    source project.vim
endif

" GitCommit()
function! GitCommit()
    let msg = input("Commit message: ")
    :echo system("git commit -am \"" . msg . "\"")
endfunction

nnoremap <leader>gs :echo system("git status")<CR>
nnoremap <leader>gc :call GitCommit()<CR>

" runfile

command! Run call runfile#Run()
command! Runout call runfile#RunFileToOutPut()

" matching chars
inoremap <expr> ( matchingChars#InsertLeftParenthesis("(")
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<esc>ko

inoremap <expr> ) matchingChars#InsertRightParenthesis(")")
inoremap <expr> ] matchingChars#InsertRightParenthesis("]")
inoremap <expr> } matchingChars#InsertRightParenthesis("}")

inoremap <expr> " matchingChars#InsertQuote("\"")
" inoremap <expr> ' matchingChars#InsertQuote("\'")

imap <expr> <BS> matchingChars#RemoveSomething()
